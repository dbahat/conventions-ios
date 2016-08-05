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
    @IBOutlet private weak var submittedEventsTabledView: UITableView!
    @IBOutlet private weak var submittedEventsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventsToSubmitTableView: UITableView!
    @IBOutlet private weak var eventsToSubmitHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var submitAllFeedbacksButtonIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var submitAllFeedbacksButton: UIButton!
    
    private let submittedEventsDataSource = EventsTableDataSource()
    private let eventsToSubmitDataSource = EventsTableDataSource()
    
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
        
        initializeEventsTableViews()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as? EventViewController;
        if let event = sender as? ConventionEvent {
            eventViewController?.event = event
        }
    }
    
    @IBAction private func submitAllEventsFeedbackWasTapped(sender: UIButton) {
        submitAllFeedbacksButton.hidden = true
        submitAllFeedbacksButtonIndicator.hidden = false
        
        var submittedEventsCount = 0;
        
        for event in eventsToSubmitDataSource.events {
            event.submitFeedback({success in
                if !success {
                    TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Middle, superView: self.view)
                        .show();
                    return
                }
                
                submittedEventsCount += 1;
                if submittedEventsCount == self.eventsToSubmitDataSource.events.count {
                    self.submitAllFeedbacksButton.hidden = false
                    self.submitAllFeedbacksButtonIndicator.hidden = true
                    
                    // reset the tableViews to reflect the new changes in submitted events
                    self.initializeEventsTableViews()
                    self.submittedEventsTabledView.reloadData()
                    self.eventsToSubmitTableView.reloadData()
                }
            })
        }
    }
    
    private func initializeEventsTableViews() {
        submittedEventsDataSource.events = Convention.instance.events.getAll().filter({$0.didSubmitFeedback()})
        submittedEventsTableViewHeightConstraint.constant = CGFloat(102 * submittedEventsDataSource.events.count)
        submittedEventsTabledView.dataSource = submittedEventsDataSource
        submittedEventsTabledView.delegate = submittedEventsDataSource
        submittedEventsDataSource.referencingViewController = self
        
        eventsToSubmitDataSource.events = Convention.instance.events.getAll().filter({$0.feedbackAnswers.count > 0 && !$0.didSubmitFeedback() && !Convention.instance.isFeedbackSendingTimeOver()})
        eventsToSubmitHeightConstraint.constant = CGFloat(102 * eventsToSubmitDataSource.events.count)
        eventsToSubmitTableView.dataSource = eventsToSubmitDataSource
        eventsToSubmitTableView.delegate = eventsToSubmitDataSource
        eventsToSubmitDataSource.referencingViewController = self
    }
    
    class EventsTableDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var events = Array<ConventionEvent>()
        weak var referencingViewController: UIViewController?
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let event = events[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(EventTableViewCell)) as! EventTableViewCell
            cell.setEvent(event)
            return cell
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let event = events[indexPath.row]
            referencingViewController?.performSegueWithIdentifier("ConventionFeedbackToEventSegue", sender: event)
        }
    }
}