
//
//  FeedbackView.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol FeedbackViewProtocol : class {
    func feedbackViewHeightDidChange(_ newHeight: CGFloat)
    
    func feedbackProvided(_ feedback: FeedbackAnswer)
    
    func feedbackCleared(_ feedback: FeedbackQuestion)
    
    func sendFeedbackWasClicked()
}

class FeedbackView : UIView, UITableViewDataSource, UITableViewDelegate, FeedbackQuestionProtocol {
    
    @IBOutlet fileprivate weak var feedbackIconContainerWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var feedbackIcon: UIImageView!
    @IBOutlet fileprivate weak var changeStateButton: UIButton!
    @IBOutlet fileprivate weak var sendButton: UIButton!
    @IBOutlet fileprivate weak var questionsTableView: UITableView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var questionsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var footerView: UIView!
    @IBOutlet fileprivate weak var sendMailIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var headerView: UIView!
    @IBOutlet fileprivate weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var textColor = Colors.textColor {
        didSet {
            titleLabel.textColor = textColor
            questionsTableView.reloadData()
        }
    }
    var buttonColor = Colors.buttonColor {
        didSet {
            changeStateButton.setTitleColor(buttonColor, for: UIControlState())
            sendButton.setTitleColor(buttonColor, for: UIControlState())
        }
    }
    
    fileprivate var questions: Array<FeedbackQuestion> = []
    fileprivate var answers: Array<FeedbackAnswer> = []
    fileprivate var isSent: Bool = false {
        didSet {
            if !isSent {
                return
            }
            
            if let rating = self.answers.getFeedbackWeightedRating() {
                feedbackIcon.image = rating.answer.getImage()
            }
            
            sendButton.setTitle("הפידבק נשלח. תודה!", for: UIControlState())
            sendButton.setTitleColor(UIColor.white, for: UIControlState())
            sendButton.isUserInteractionEnabled = false
        }
    }
    
    weak var delegate: FeedbackViewProtocol?
    
    fileprivate let headerHeight = CGFloat(30)
    fileprivate let footerHeight = CGFloat(31)
    fileprivate let paddingSize = CGFloat(10)
    
    var state: State = State.collapsed {
        didSet {
            switch state {
            case .expended:
                footerView.isHidden = false
                footerHeightConstraint.constant = footerHeight
                questionsTableHeightConstraint.constant = questions.height
                changeStateButton.setTitle("הסתר",for: UIControlState())
                titleLabel.text = "פידבק"
                feedbackIconContainerWidth.constant = 0
                
            case .collapsed:
                footerView.isHidden = true
                footerHeightConstraint.constant = 0
                questionsTableHeightConstraint.constant = 0
                changeStateButton.setTitle(isSent ? "הצג פידבק" : "מלא פידבק",for: UIControlState())
                titleLabel.text = getCollapsedTitleLabel()
                feedbackIconContainerWidth.constant = 38
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = Bundle.main.loadNibNamed(String(describing: FeedbackView.self), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view);
        
        feedbackIcon.image = feedbackIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        feedbackIcon.tintColor = UIColor.white
        
        // Register all cells dynamiclly, since we want each cell to have a seperate xib file
        questionsTableView.register(UINib(nibName: String(describing: SmileyFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SmileyFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: TextFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: MultipleAnswerFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MultipleAnswerFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: TableMultipleAnswerFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableMultipleAnswerFeedbackQuestionCell.self))
        
        changeStateButton.setTitleColor(Colors.buttonColor, for: UIControlState())
        sendButton.setTitleColor(Colors.buttonColor, for: UIControlState())
        titleLabel.textColor = textColor
    }
    
    func setFeedback(questions: Array<FeedbackQuestion>, answers: Array<FeedbackAnswer>, isSent: Bool) {
        self.questions = questions
        self.answers = answers
        self.isSent = isSent
        
        if isSent {
            // Filter out un-answered questions
            self.questions = questions.filter({question in
                answers.contains(where: {answer in question.question == answer.questionText})
            })
        } else {
            if Convention.instance.isFeedbackSendingTimeOver() {
                sendButton.setTitle("זמן שליחת הפידבק הסתיים", for: UIControlState())
                sendButton.setTitleColor(UIColor.white, for: UIControlState())
                sendButton.isUserInteractionEnabled = false
            } else {
                // Disable the send button unless the user answers a question
                sendButton.isEnabled = answers.count > 0
            }
        }
        
        questionsTableView.reloadData()
    }
    
    func removeAnsweredQuestions(_ answers: Array<FeedbackAnswer>) {
        self.answers = answers
        
        var indexesToUpdate = Array<IndexPath>()
        var answeredQuestions = Array<FeedbackQuestion>()
        
        // get the indexes of all un-answered questions, so we can animate their removal
        for index in 0...(questions.count - 1) {
            let question = questions[index]
            if !answers.contains(where: {answer in answer.questionText == question.question}) {
                indexesToUpdate.append(IndexPath(row: index, section: 0))
            } else {
                answeredQuestions.append(question)
            }
        }
        
        questions = answeredQuestions
        questionsTableView.deleteRows(at: indexesToUpdate, with: UITableViewRowAnimation.automatic)
        questionsTableHeightConstraint.constant = questions.height
    }
    
    func getHeight() -> CGFloat {
        switch state {
        case .collapsed:
            return headerView.frame.size.height + 2 * paddingSize
        case .expended:
            return paddingSize + headerViewHeightConstraint.constant + 2 * paddingSize + questions.height + footerHeight + paddingSize
        }
    }
    
    func setHeaderHidden(_ hidden: Bool) {
        headerView.isHidden = hidden
        headerViewHeightConstraint.constant = hidden ? 0 : headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cellId = String(describing: question.answerType) + String(describing: FeedbackQuestionCell.self)
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: cellId)! as! FeedbackQuestionCell
        cell.delegate = self
        cell.question = question
        cell.feedbackTextColor = textColor
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let question = questions[indexPath.row]
        return question.viewHeight
    }
    
    func questionWasAnswered(_ answer: FeedbackAnswer) {
        delegate?.feedbackProvided(answer)
    }
    
    func questionCleared(_ question: FeedbackQuestion) {
        delegate?.feedbackCleared(question)
    }
    
    func questionViewHeightChanged(caller: UITableViewCell, newHeight: CGFloat) {
        guard let indexPath = questionsTableView.indexPath(for: caller) else {
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
    
    func setFeedbackAsSent(_ success: Bool) {
        sendMailIndicator.stopAnimating()
        sendButton.isHidden = false
        isSent = success
    }
    
    func setSendButtonEnabled(_ enabled: Bool) {
        sendButton.isEnabled = enabled;
    }

    @IBAction fileprivate func headerWasClicked(_ sender: UITapGestureRecognizer) {
        state = state.toggle()
        
        delegate?.feedbackViewHeightDidChange(getHeight())
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) 
    }
    
    @IBAction fileprivate func sendWasClicked(_ sender: UIButton) {
        sendMailIndicator.startAnimating()
        sendButton.isHidden = true
        
        delegate?.sendFeedbackWasClicked()
    }
    
    fileprivate func getCollapsedTitleLabel() -> String {
        if isSent {
            return "הפידבק נשלח. תודה!"
        }
        
        return Convention.instance.isFeedbackSendingTimeOver() ? "זמן שליחת הפידבק הסתיים" : "האירוע נגמר"
    }
    
    enum State {
        case expended
        case collapsed
        
        func toggle() -> State {
            switch self {
            case .expended:
                return .collapsed
            case .collapsed:
                return . expended
            }
        }
    }
}

private extension Array where Element: FeedbackQuestion {
    var height: CGFloat {
        get {
            return self.reduce(0, {totalHight, question in totalHight + question.viewHeight})
        }
    }
}
