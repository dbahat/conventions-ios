//
//  ConventionFeedbackViewController.swift
//  Conventions
//
//  Created by David Bahat on 7/22/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class ConventionFeedbackViewController: BaseViewController, FeedbackViewProtocol {
    
    @IBOutlet private weak var feedbackView: FeedbackView!
    @IBOutlet private weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    
    private var userInputs: UserInput.Feedback {
        get {
            return Convention.instance.feedback.conventionInputs
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackView.delegate = self
        feedbackView.setHeaderHidden(true)
        
        feedbackView.setFeedback(
            questions: Convention.instance.feedbackQuestions,
            answers: userInputs.answers,
            isSent: userInputs.isSent)
        
        // In this view the feedbackView should always be expended.
        // Note - should be done after setting the questions/answers, since they affect the view height.
        feedbackView.state = .Expended
        
        // Need to set the view height constrant only after we set the 
        // feedback and it's collapsed state, since its size changes based on the questions and state
        feedbackViewHeightConstraint.constant = feedbackView.getHeight()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Saving to the filesystem only when leaving the screen, since we don't want to save
        // on each small change inside free-text questions
        Convention.instance.feedback.save()
    }
    
    func feedbackProvided(feedback: FeedbackAnswer) {
        // If the answer already exists, override it
        if let existingAnswerIndex = userInputs.answers.indexOf({$0.questionText == feedback.questionText}) {
            userInputs.answers.removeAtIndex(existingAnswerIndex)
        }
        userInputs.answers.append(feedback)
        Convention.instance.feedback.save()
        
        feedbackView.setSendButtonEnabled(userInputs.answers.count > 0)
    }
    
    func feedbackCleared(feedback: FeedbackQuestion) {
        guard let existingAnswerIndex = userInputs.answers.indexOf({$0.questionText == feedback.question}) else {
            // no existing answer means nothing to clear
            return
        }
        userInputs.answers.removeAtIndex(existingAnswerIndex);
        
        feedbackView.setSendButtonEnabled(userInputs.answers.count > 0)
    }
    
    func sendFeedbackWasClicked() {
        Convention.instance.feedback.conventionInputs.submit("פידבק לכנס " + Convention.displayName, callback: {success in
            
            self.feedbackView.setFeedbackAsSent(success)
            
            if !success {
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Middle, superView: self.view)
                    .show();
                return;
            }
            
            // filter un-answered questions and animate the possible layout height change
            self.feedbackView.removeAnsweredQuestions(self.userInputs.answers)
            self.feedbackViewHeightConstraint.constant = self.feedbackView.getHeight()
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
            }
        })
    }
    
    func feedbackViewHeightDidChange(newHeight: CGFloat) {
        feedbackViewHeightConstraint.constant = newHeight
    }
}
