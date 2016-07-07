
//
//  EventsFeedbackView.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol EventFeedbackViewProtocol : class {
    func feedbackViewHeightDidChange(newHeight: CGFloat)
    
    func feedbackProvided(feedback: FeedbackAnswer)
    
    func feedbackCleared(feedback: FeedbackQuestion)
    
    func sendFeedbackWasClicked()
}

class EventsFeedbackView : UIView, UITableViewDataSource, UITableViewDelegate, FeedbackQuestionProtocol {
    
    @IBOutlet private weak var changeStateButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var questionsTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var sendMailIndicator: UIActivityIndicatorView!
    
    private var questions: Array<FeedbackQuestion> = []
    private var answers: Array<FeedbackAnswer> = []
    
    weak var delegate: EventFeedbackViewProtocol?
    
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
                
            case .Collapsed:
                footerView.hidden = true
                footerHeightConstraint.constant = 0
                questionsTableHeightConstraint.constant = 0
                changeStateButton.setTitle("מלא פידבק",forState: .Normal)
                titleLabel.text = "האירוע נגמר"
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed(String(EventsFeedbackView), owner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        addSubview(view);
    }
    
    func setFeedback(questions questions: Array<FeedbackQuestion>, answers: Array<FeedbackAnswer>) {
        self.questions = questions
        self.answers = answers
        
        // Register all cells dynamiclly, since we want each cell to have a seperate xib file
        questionsTableView.registerNib(UINib(nibName: String(SmileyFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(SmileyFeedbackQuestionCell))
        questionsTableView.registerNib(UINib(nibName: String(TextFeedbackQuestionCell), bundle: nil), forCellReuseIdentifier: String(TextFeedbackQuestionCell))
        
        questionsTableView.reloadData()
    }
    
    func getHeight() -> CGFloat {
        switch state {
        case .Collapsed:
            return headerHeight + 2 * paddingSize
        case .Expended:
            let questionsLayoutHeight = questions.height
            return headerHeight + 2 * paddingSize + questionsLayoutHeight + footerHeight + paddingSize
        }
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
        
        if let foundAnswer = answers.filter({answer in answer.questionText == question.question}).first {
            cell.setAnswer(foundAnswer)
            
            if (question.viewHeight != question.answerType.defaultHeight + cell.cellHeightDelta) {
                question.viewHeight = question.answerType.defaultHeight + cell.cellHeightDelta
                
                questionsTableHeightConstraint.constant = questions.height
                delegate?.feedbackViewHeightDidChange(getHeight())
            }
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
        
        if (success) {
            state = .Collapsed
            delegate?.feedbackViewHeightDidChange(getHeight())
            
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        } else {
            sendButton.hidden = false
        }
    }

    @IBAction func headerWasClicked(sender: UITapGestureRecognizer) {
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

extension Array where Element: FeedbackQuestion {
    var height: CGFloat {
        get {
            return self.reduce(0, combine: {totalHight, question in totalHight + question.viewHeight})
        }
    }
}