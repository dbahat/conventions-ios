//
//  ConventionFeedbackViewController.swift
//  Conventions
//
//  Created by David Bahat on 7/22/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import Firebase

class ConventionFeedbackViewController: BaseViewController, FeedbackViewProtocol {
    
    @IBOutlet fileprivate weak var filledEventsFeedbackLabel: UILabel!
    @IBOutlet fileprivate weak var seperatorView: UIView!
    @IBOutlet fileprivate weak var sendAllFeedbackDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var sendFeedbackContainer: UIView!
    @IBOutlet fileprivate weak var sendFeedbackContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var feedbackView: FeedbackView!
    @IBOutlet fileprivate weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var submittedEventsTabledView: UITableView!
    @IBOutlet fileprivate weak var submittedEventsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var eventsToSubmitTableView: UITableView!
    @IBOutlet fileprivate weak var eventsToSubmitHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var submitAllFeedbacksButtonIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var submitAllFeedbacksButton: UIButton!
    
    fileprivate let submittedEventsDataSource = EventsTableDataSource()
    fileprivate let eventsToSubmitDataSource = EventsTableDataSource()
    
    fileprivate var userInputs: UserInput.Feedback {
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
        feedbackView.state = .expended
        
        // Need to set the view height constrant only after we set the 
        // feedback and it's collapsed state, since its size changes based on the questions and state
        feedbackViewHeightConstraint.constant = feedbackView.getHeight()
        
        initializeEventsTableViews()
        
        navigationItem.title = "פידבק לפסטיבל"
        submitAllFeedbacksButton.setTitleColor(Colors.buttonColor, for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConventionFeedbackViewController.keyboardFrameWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Saving to the filesystem only when leaving the screen, since we don't want to save
        // on each small change inside free-text questions
        Convention.instance.feedback.save()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func feedbackProvided(_ feedback: FeedbackAnswer) {
        // If the answer already exists, override it
        if let existingAnswerIndex = userInputs.answers.index(where: {$0.questionText == feedback.questionText}) {
            userInputs.answers.remove(at: existingAnswerIndex)
        }
        userInputs.answers.append(feedback)
        Convention.instance.feedback.save()
        
        feedbackView.setSendButtonEnabled(userInputs.answers.count > 0)
    }
    
    func feedbackCleared(_ feedback: FeedbackQuestion) {
        guard let existingAnswerIndex = userInputs.answers.index(where: {$0.questionText == feedback.question}) else {
            // no existing answer means nothing to clear
            return
        }
        userInputs.answers.remove(at: existingAnswerIndex);
        
        feedbackView.setSendButtonEnabled(userInputs.answers.count > 0)
    }
    
    func sendFeedbackWasClicked() {
        // Force close the keyboard
        view.endEditing(true)
        
        Convention.instance.conventionFeedbackForm.submit(conventionName: Convention.displayName, answers: userInputs.answers, callback: { success in
            
            Convention.instance.feedback.conventionInputs.isSent = success
            self.feedbackView.setFeedbackAsSent(success)
            
            
            Analytics.logEvent("ConventionFeedback", parameters: [
                "name": "SendAttempt" as NSObject,
                "full_text": success ? "success" : "failure" as NSObject
                ])
            
            if !success {
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                return
            }
            
            // Cancel the convention feedback reminder notifications (so the user won't see it again)
            NotificationsSchedualer.removeConventionFeedback()
            NotificationsSchedualer.removeConventionFeedbackLastChance()
            
            // filter un-answered questions and animate the possible layout height change
            self.feedbackView.removeAnsweredQuestions(self.userInputs.answers)
            self.feedbackViewHeightConstraint.constant = self.feedbackView.getHeight()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func feedbackViewHeightDidChange(_ newHeight: CGFloat) {
        feedbackViewHeightConstraint.constant = newHeight
    }
    
    // Resize the screen to be at the height minus the keyboard, so that the keyboard won't hide the user's feedback
    @objc func keyboardFrameWillChange(_ notification: Notification) {
        let keyboardBeginFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue
        let keyboardEndFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        
        let animationCurve = UIViewAnimationCurve(rawValue: ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey)! as AnyObject).intValue)
        
        let animationDuration: TimeInterval = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationDurationUserInfoKey)! as AnyObject).doubleValue
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve!)
        
        var newFrame = self.view.frame
        let keyboardFrameEnd = self.view.convert(keyboardEndFrame!, to: nil)
        let keyboardFrameBegin = self.view.convert(keyboardBeginFrame!, to: nil)
        
        newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)
        self.view.frame = newFrame;
        
        UIView.commitAnimations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventViewController = segue.destination as? EventViewController;
        if let event = sender as? ConventionEvent {
            eventViewController?.event = event
        }
    }
    
    @IBAction fileprivate func submitAllEventsFeedbackWasTapped(_ sender: UIButton) {
        submitAllFeedbacksButton.isHidden = true
        submitAllFeedbacksButtonIndicator.isHidden = false
        
        var submittedEventsCount = 0;
        
        for event in eventsToSubmitDataSource.events {
            event.submitFeedback({success in
                if !success {
                    TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.middle, superView: self.view)
                        .show();
                    return
                }
                
                submittedEventsCount += 1;
                if submittedEventsCount == self.eventsToSubmitDataSource.events.count {
                    self.submitAllFeedbacksButton.isHidden = false
                    self.submitAllFeedbacksButtonIndicator.isHidden = true
                    
                    // reset the tableViews to reflect the new changes in submitted events
                    self.initializeEventsTableViews()
                    self.submittedEventsTabledView.reloadData()
                    self.eventsToSubmitTableView.reloadData()
                }
            })
        }
    }
    
    fileprivate func initializeEventsTableViews() {
        submittedEventsDataSource.events = Convention.instance.events.getAll().filter({$0.didSubmitFeedback()})
        submittedEventsTableViewHeightConstraint.constant = CGFloat(102 * submittedEventsDataSource.events.count)
        submittedEventsTabledView.dataSource = submittedEventsDataSource
        submittedEventsTabledView.delegate = submittedEventsDataSource
        submittedEventsDataSource.referencingViewController = self
        
        eventsToSubmitDataSource.events = Convention.instance.events.getAll().filter({
            ($0.feedbackAnswers.count > 0 || $0.attending)
            && $0.canFillFeedback()
            && !$0.didSubmitFeedback()
            && !Convention.instance.isFeedbackSendingTimeOver()})
        eventsToSubmitHeightConstraint.constant = CGFloat(102 * eventsToSubmitDataSource.events.count)
        eventsToSubmitTableView.dataSource = eventsToSubmitDataSource
        eventsToSubmitTableView.delegate = eventsToSubmitDataSource
        eventsToSubmitDataSource.referencingViewController = self
        
        if eventsToSubmitDataSource.events.count == 0 && submittedEventsDataSource.events.count == 0 {
            sendFeedbackContainerHeightConstraint.constant = 81
            sendFeedbackContainer.isHidden = false
            submitAllFeedbacksButton.isHidden = true
            seperatorView.isHidden = true
            filledEventsFeedbackLabel.isHidden = true
            sendAllFeedbackDescriptionLabel.text = "בחר אירועים שהיית בהם דרך התוכניה ומלא עליהם פידבק"
        } else if eventsToSubmitDataSource.events.count == 0 {
            sendFeedbackContainerHeightConstraint.constant = 0
            sendFeedbackContainer.isHidden = true
        } else {
            sendFeedbackContainerHeightConstraint.constant = eventsToSubmitHeightConstraint.constant + 116
            sendFeedbackContainer.isHidden = false
        }
    }
    
    class EventsTableDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var events = Array<ConventionEvent>()
        weak var referencingViewController: UIViewController?
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let event = events[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self)) as! EventTableViewCell
            cell.setEvent(event)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let event = events[indexPath.row]
            referencingViewController?.performSegue(withIdentifier: "ConventionFeedbackToEventSegue", sender: event)
        }
    }
}
