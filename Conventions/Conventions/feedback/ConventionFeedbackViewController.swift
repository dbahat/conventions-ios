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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbackView.setFeedback(questions: Convention.instance.feedbackQuestions,
                                      answers: Convention.instance.feedback.conventionInputs.answers,
                                      isSent: Convention.instance.feedback.conventionInputs.isSent)
        feedbackView.delegate = self
        feedbackView.setHeaderHidden(true)
        feedbackView.state = .Expended
        feedbackViewHeightConstraint.constant = feedbackView.getHeight()
    }
    
    func feedbackProvided(feedback: FeedbackAnswer) {
        // If the answer already exists, override it
        if let existingAnswerIndex = Convention.instance.feedback.conventionInputs.answers.indexOf({$0.questionText == feedback.questionText}) {
            Convention.instance.feedback.conventionInputs.answers.removeAtIndex(existingAnswerIndex)
        }
        Convention.instance.feedback.conventionInputs.answers.append(feedback)
        Convention.instance.feedback.save()
    }
    
    func feedbackCleared(feedback: FeedbackQuestion) {
        guard let existingAnswerIndex = Convention.instance.feedback.conventionInputs.answers.indexOf({$0.questionText == feedback.question}) else {
            // no existing answer means nothing to clear
            return
        }
        Convention.instance.feedback.conventionInputs.answers.removeAtIndex(existingAnswerIndex);
        Convention.instance.feedback.save()
    }
    
    func sendFeedbackWasClicked() {
        Convention.instance.feedback.conventionInputs.submit("פידבק לכנס " + Convention.displayName, callback: {success in
            
            self.feedbackView.setFeedbackAsSent(success)
            self.feedbackView.setFeedback(questions: Convention.instance.feedbackQuestions,
                answers: Convention.instance.feedback.conventionInputs.answers,
                isSent: Convention.instance.feedback.conventionInputs.isSent)
            
            if !success {
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Middle, superView: self.view)
                    .show();
            }
        })
    }
    
    func feedbackViewHeightDidChange(newHeight: CGFloat) {
        feedbackViewHeightConstraint.constant = newHeight
    }
}
