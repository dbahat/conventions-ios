
//
//  FeedbackView.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol FeedbackViewProtocol : class {
    func feedbackViewHeightDidChange(newHeight: CGFloat)
    
    func feedbackProvided(feedback: FeedbackAnswer)
    
    func feedbackCleared(feedback: FeedbackQuestion)
    
    func sendFeedbackWasClicked()
}

class FeedbackView : UIView, UITableViewDataSource, UITableViewDelegate, FeedbackQuestionProtocol {
    
    @IBOutlet private weak var feedbackIconContainerWidth: NSLayoutConstraint!
    @IBOutlet private weak var feedbackIcon: UIImageView!
    @IBOutlet private weak var changeStateButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var questionsTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var sendMailIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    private var questions: Array<FeedbackQuestion> = []
    private var answers: Array<FeedbackAnswer> = []
    private var isSent: Bool = false {
        didSet {
            if !isSent {
                return
            }
            
            if let rating = self.answers.getFeedbackWeightedRating() {
                feedbackIcon.image = rating.answer.getImage()
            }
            
            sendButton.setTitle("הפידבק נשלח. תודה!", forState: .Normal)
            sendButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            sendButton.userInteractionEnabled = false
        }
    }
    
    weak var delegate: FeedbackViewProtocol?
    
    private let headerHeight = CGFloat(30)
    private let footerHeight = CGFloat(31)
    private let paddingSize = CGFloat(10)
    
    var state: State = State.Collapsed {
        didSet {
            switch state {
            case .Expended:
                footerView.hidden = false
                footerHeightConstraint.constant = footerHeight
                questionsTableHeightConstraint.constant = questions.height
                changeStateButton.setTitle("הסתר",forState: .Normal)
                titleLabel.text = "פידבק"
                feedbackIconContainerWidth.constant = 0
                
            case .Collapsed:
                footerView.hidden = true
                footerHeightConstraint.constant = 0
                questionsTableHeightConstraint.constant = 0
                changeStateButton.setTitle(isSent ? "הצג פידבק" : "מלא פידבק",forState: .Normal)
                titleLabel.text = getCollapsedTitleLabel()
                feedbackIconContainerWidth.constant = 38
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed(String(FeedbackView), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view);
        
        feedbackIcon.image = feedbackIcon.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        feedbackIcon.tintColor = Colors.colorAccent
        
        // Register all cells dynamiclly, since we want each cell to have a seperate xib file
        questionsTableView.registerNib(UINib(nibName: String(SmileyFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(SmileyFeedbackQuestionCell))
        questionsTableView.registerNib(UINib(nibName: String(TextFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(TextFeedbackQuestionCell))
        questionsTableView.registerNib(UINib(nibName: String(MultipleAnswerFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(MultipleAnswerFeedbackQuestionCell))
        questionsTableView.registerNib(UINib(nibName: String(TableMultipleAnswerFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(TableMultipleAnswerFeedbackQuestionCell))
        
        changeStateButton.setTitleColor(Colors.buttonColor, forState: .Normal)
        sendButton.setTitleColor(Colors.buttonColor, forState: .Normal)
    }
    
    func setFeedback(questions questions: Array<FeedbackQuestion>, answers: Array<FeedbackAnswer>, isSent: Bool) {
        self.questions = questions
        self.answers = answers
        self.isSent = isSent
        
        if isSent {
            // Filter out un-answered questions
            self.questions = questions.filter({question in
                answers.contains({answer in question.question == answer.questionText})
            })
        } else {
            if Convention.instance.isFeedbackSendingTimeOver() {
                sendButton.setTitle("זמן שליחת הפידבק הסתיים", forState: .Normal)
                sendButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                sendButton.userInteractionEnabled = false
            } else {
                // Disable the send button unless the user answers a question
                sendButton.enabled = answers.count > 0
            }
        }
        
        questionsTableView.reloadData()
    }
    
    func removeAnsweredQuestions(answers: Array<FeedbackAnswer>) {
        self.answers = answers
        
        var indexesToUpdate = Array<NSIndexPath>()
        var answeredQuestions = Array<FeedbackQuestion>()
        
        // get the indexes of all un-answered questions, so we can animate their removal
        for index in 0...(questions.count - 1) {
            let question = questions[index]
            if !answers.contains({answer in answer.questionText == question.question}) {
                indexesToUpdate.append(NSIndexPath(forRow: index, inSection: 0))
            } else {
                answeredQuestions.append(question)
            }
        }
        
        questions = answeredQuestions
        questionsTableView.deleteRowsAtIndexPaths(indexesToUpdate, withRowAnimation: UITableViewRowAnimation.Automatic)
        questionsTableHeightConstraint.constant = questions.height
    }
    
    func getHeight() -> CGFloat {
        switch state {
        case .Collapsed:
            return headerView.frame.size.height + 2 * paddingSize
        case .Expended:
            return paddingSize + headerViewHeightConstraint.constant + 2 * paddingSize + questions.height + footerHeight + paddingSize
        }
    }
    
    func setHeaderHidden(hidden: Bool) {
        headerView.hidden = hidden
        headerViewHeightConstraint.constant = hidden ? 0 : headerHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cellId = String(question.answerType) + String(FeedbackQuestionCell)
        let cell = questionsTableView.dequeueReusableCellWithIdentifier(cellId)! as! FeedbackQuestionCell
        cell.delegate = self
        cell.question = question
        
        // disable the question cell interactions if the feedback was already sent
        cell.enabled = !isSent
        
        if let foundAnswer = answers.filter({answer in answer.questionText == question.question}).first {
            cell.setAnswer(foundAnswer)
        }
        
        if (question.viewHeight != question.answerType.defaultHeight + cell.cellHeightDelta) {
            question.viewHeight = question.answerType.defaultHeight + cell.cellHeightDelta
            
            questionsTableHeightConstraint.constant = questions.height
            delegate?.feedbackViewHeightDidChange(getHeight())
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let question = questions[indexPath.row]
        return question.viewHeight
    }
    
    func questionWasAnswered(answer: FeedbackAnswer) {
        delegate?.feedbackProvided(answer)
    }
    
    func questionCleared(question: FeedbackQuestion) {
        delegate?.feedbackCleared(question)
    }
    
    func questionViewHeightChanged(caller caller: UITableViewCell, newHeight: CGFloat) {
        guard let indexPath = questionsTableView.indexPathForCell(caller) else {
            // if the calling cell is not in the model, ignore it's event
            return
        }
        
        let question = questions[indexPath.row]
        question.viewHeight = question.answerType.defaultHeight + newHeight
        
        questionsTableView.beginUpdates()
        questionsTableView.endUpdates()
        
        questionsTableHeightConstraint.constant = questions.height
        delegate?.feedbackViewHeightDidChange(getHeight())
    }
    
    func setFeedbackAsSent(success: Bool) {
        sendMailIndicator.stopAnimating()
        sendButton.hidden = false
        isSent = success
    }
    
    func setSendButtonEnabled(enabled: Bool) {
        sendButton.enabled = enabled;
    }

    @IBAction private func headerWasClicked(sender: UITapGestureRecognizer) {
        state = state.toggle()
        
        delegate?.feedbackViewHeightDidChange(getHeight())
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction private func sendWasClicked(sender: UIButton) {
        sendMailIndicator.startAnimating()
        sendButton.hidden = true
        
        delegate?.sendFeedbackWasClicked()
    }
    
    private func getCollapsedTitleLabel() -> String {
        if isSent {
            return "הפידבק נשלח. תודה!"
        }
        
        return Convention.instance.isFeedbackSendingTimeOver() ? "זמן שליחת הפידבק הסתיים" : "האירוע נגמר"
    }
    
    enum State {
        case Expended
        case Collapsed
        
        func toggle() -> State {
            switch self {
            case .Expended:
                return .Collapsed
            case .Collapsed:
                return . Expended
            }
        }
    }
}

private extension Array where Element: FeedbackQuestion {
    var height: CGFloat {
        get {
            return self.reduce(0, combine: {totalHight, question in totalHight + question.viewHeight})
        }
    }
}
