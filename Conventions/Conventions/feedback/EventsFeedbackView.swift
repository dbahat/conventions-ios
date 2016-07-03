//
//  EventsFeedbackView.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol EventFeedbackViewProtocol : class {
    func changeFeedbackViewStateWasClicked(newState: EventsFeedbackView.State)
    
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
    
    var state: State = State.Collapsed {
        didSet {
            switch state {
            case .Expended:
                footerView.hidden = false
                footerHeightConstraint.constant = 31
                questionsTableHeightConstraint.constant = CGFloat(102 * questions.count)
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
    
    func getSize() -> CGFloat {
        switch state {
        case .Collapsed:
            return 50 // TODO - Replace with actual size calculations
        case .Expended:
            return CGFloat(91 + questions.count * 102)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cellId = String(question.answerType) + "FeedbackQuestionCell"
        let cell = questionsTableView.dequeueReusableCellWithIdentifier(cellId)! as! FeedbackQuestionCell
        cell.question = question
        cell.delegate = self
        return cell
    }
    
    func questionWasAnswered(answer: FeedbackAnswer) {
        delegate?.feedbackProvided(answer)
    }
    
    func questionCleared(question: FeedbackQuestion) {
        delegate?.feedbackCleared(question)
    }
    
    func setFeedbackAsSent(success: Bool) {
        sendMailIndicator.stopAnimating()
        
        if (success) {
            state = .Collapsed
            delegate?.changeFeedbackViewStateWasClicked(state)
            
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        } else {
            sendButton.hidden = false
        }
    }
    
    @IBAction private func changeStateWasClicked(sender: UIButton) {
        state = state.toggle()
        
        delegate?.changeFeedbackViewStateWasClicked(state)

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