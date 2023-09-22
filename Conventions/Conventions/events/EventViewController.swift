//
//  EventViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventViewController: BaseViewController, FeedbackViewProtocol, UITextViewDelegate {

    var event: ConventionEvent!
    var feedbackViewOpen: Bool = false
    
    @IBOutlet private weak var toastView: UIView!
    @IBOutlet fileprivate weak var eventTitleBoxBoarderView: UIView!
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var eventTitleContainer: UIView!
    
    @IBOutlet private weak var eventTitleContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventSubTitle: UILabel!
    @IBOutlet private weak var eventSubTitleContainer: UIView!
    @IBOutlet private weak var eventTypeAndCategory: UILabel!
    @IBOutlet private weak var eventTypeAndCategoryContainer: UIView!
    
    @IBOutlet fileprivate weak var hall: UILabel!
    @IBOutlet fileprivate weak var time: UILabel!
    @IBOutlet fileprivate weak var tags: UILabel!
    @IBOutlet fileprivate weak var prices: UILabel!
    @IBOutlet fileprivate weak var titleAndEventTypeContainer: UIView!
    @IBOutlet fileprivate weak var metadataContainer: UIView!
    @IBOutlet fileprivate weak var lecturerAndMetadataContainer: UIStackView!
    
    @IBOutlet fileprivate weak var refreshAvailableTicketsButton: UIImageView!

    @IBOutlet private weak var eventDescriptionTextView: UITextView!
    
    @IBOutlet fileprivate weak var image: UIImageView!
    @IBOutlet fileprivate weak var eventDescriptionContainer: UIView!
    @IBOutlet fileprivate weak var feedbackView: FeedbackView!
    @IBOutlet fileprivate weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var availableTickets: UILabel!
    @IBOutlet weak var OpenEventContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var openEventLabel: UILabel!
    @IBOutlet weak var OpenEventButton: UIButton!
    @IBOutlet weak var openEventConatiner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event.canFillFeedback() {
            feedbackView.backgroundColor = Colors.eventFeedbackBoxColor
            feedbackView.layer.borderWidth = 0
            feedbackView.layer.borderColor = Colors.textColor.cgColor
            
            feedbackView.delegate = self
            feedbackView.setFeedback(questions: event.feedbackQuestions,
                                     answers: event.feedbackAnswers,
                                     isSent: event.didSubmitFeedback())
            feedbackView.textColor = Colors.eventFeedbackTextColor
            feedbackView.buttonColor = Colors.feedbackButtonColorEvent
            feedbackView.buttonColorPressed = Colors.buttonPressedColor
            feedbackView.answerButtonsColor = Colors.feedbackButtonColorEvent
            feedbackView.linkColor = Colors.feedbackLinksColorEvent
            feedbackView.answerButtonsPressedColor = Colors.feedbackButtonPressedColor
            
            if (event.didSubmitFeedback()) {
                feedbackView.state = .collapsed
            } else if event.attending || event.feedbackAnswers.count > 0 || feedbackViewOpen {
                // If the user marked this as favorite or started filling feedback for the event
                feedbackView.state = .expended
            } else {
                feedbackView.state = .collapsed
            }
            
            // Need to get the view height only after setting it's collapsed/expanded state
            feedbackViewHeightConstraint.constant = feedbackView.getHeight()
        } else {
            feedbackView.isHidden = true
            feedbackViewHeightConstraint.constant = 0
        }
                
        eventTitle.textColor = Colors.eventTitleTextColor
        eventSubTitle.textColor = Colors.eventSubTitleTextColor
        eventTypeAndCategory.textColor = Colors.eventTitleTextColor
        eventTitleContainer.backgroundColor = Colors.icon2023_brown1
        eventSubTitleContainer.backgroundColor = Colors.icon2023_brown8
        eventTypeAndCategoryContainer.backgroundColor = Colors.icon2023_brown3
        
        hall.textColor = Colors.textColor
        time.textColor = Colors.textColor
        prices.textColor = Colors.textColor
        tags.textColor = Colors.textColor
        
        
        titleAndEventTypeContainer.backgroundColor = Colors.eventTitleBackground
        eventTitleBoxBoarderView.backgroundColor = Colors.eventTitleBoarderColor
        metadataContainer.backgroundColor = Colors.eventTitleBoxColor
        lecturerAndMetadataContainer.layer.borderWidth = 0
        lecturerAndMetadataContainer.layer.borderColor = Colors.textColor.cgColor
        
        feedbackView.event = event
        if let lecturer = event.lecturer {
            eventTitle.text = lecturer
            if lecturer.isEmpty {
                eventTitleContainerHeightConstraint.isActive = true
                eventTitleContainerHeightConstraint.constant = 0
            }
        }
        
        eventSubTitle.text = event.type.description
        eventTypeAndCategory.text =  event.title
        hall.text = event.hall.name
        
        time.text = event.hall.name + ", " + event.startTime.format("EEE dd.MM") + ", " + event.startTime.format("HH:mm") + " - " + event.endTime.format("HH:mm")
        time.font = UIFont.boldSystemFont(ofSize: 15)
        
        prices.text = String(format: "%d ש״ח, תעריף עמותות מארגנות: %d ש״ח", event.price, event.price > 10 ? event.price - 10 : 0)
        tags.text = String(format: "%@",
                           "תגיות: " + event.tags.joined(separator: ", ")
                           )
        
        if let availableTicketsCount = event.availableTickets, availableTicketsCount >= 0, event.isTicketless == false {
            updateAvailableTicketsText(availableTicketsCount: availableTicketsCount)
        } else {
            availableTickets.removeFromSuperview()
            refreshAvailableTicketsButton.removeFromSuperview()
        }
        
        navigationItem.title = event.type.description
        
        eventDescriptionContainer.isHidden = event.description == ""
        eventDescriptionContainer.backgroundColor = Colors.eventDetailsBoxColor
        eventDescriptionContainer.layer.borderWidth = 0
        eventDescriptionContainer.layer.borderColor = Colors.textColor.cgColor
        eventDescriptionTextView.delegate = self
        refreshFavoriteBarIconImage()
        
        refreshAvailableTicketsButton.image = UIImage(named: "MenuUpdates")?.withRenderingMode(.alwaysTemplate)
        refreshAvailableTicketsButton.tintColor = Colors.textColor
        
        if event.directWatchAvailable && event.isEventAvailable() {
            OpenEventContainerHeightConstraint.constant = 66
            openEventLabel.textColor = Colors.textColor
            OpenEventButton.setTitleColor(Colors.buttonColor, for: .normal)
            OpenEventButton.setTitleColor(Colors.buttonPressedColor, for: .selected)
            openEventConatiner.backgroundColor = Colors.eventOpenEventConatinerColor
            openEventConatiner.layer.borderWidth = 0
            openEventConatiner.layer.borderColor = Colors.textColor.cgColor
        } else {
            OpenEventContainerHeightConstraint.constant = 0
            openEventLabel.isHidden = true
            OpenEventButton.isHidden = true
        }
        
        if let eventDescription = event.description {
            eventDescriptionTextView.attributedText = eventDescription.htmlAttributedString(color: Colors.eventDescriptionTextColor)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Convention.instance.eventsInputs.save()
    }
    
    private func formatPredentationMode(_ mode: EventType.PredentationMode) -> String {
        switch mode {
        case .Hybrid:
            return "היברידי"
        case .Virtual:
            return "וירטואלי"
        case .Physical:
            return "פיזי"
        }
    }
    
    @IBAction func changeFavoriteStateClicked(_ sender: UIBarButtonItem) {
        event.attending = !event.attending;
        
        refreshFavoriteBarIconImage();
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.short, superView: toastView)
            .show();
    }
    
    @IBAction func refreshAvailableTicketsButtonWasClicked(_ sender: UITapGestureRecognizer) {
        refreshAvailableTicketsButton.startRotate()
        
        event.refreshAvailableTickets({result in
            self.refreshAvailableTicketsButton.stopRotate()
            guard let availableTicketsCount = self.event.availableTickets else {
                return
            }
            self.updateAvailableTicketsText(availableTicketsCount: availableTicketsCount)
        })
    }
    
    @IBAction func OpenEventButtonWasClicked(_ sender: UIButton) {
        guard let url = event.directWatchUrl else {
            return
        }
        UIApplication.shared.open(url, options: [:]) { (success) in }
    }
    
    // MARK: - EventFeedbackViewProtocol
    
    func feedbackViewHeightDidChange(_ newHeight: CGFloat) {
        feedbackViewHeightConstraint.constant = newHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func feedbackProvided(_ feedback: FeedbackAnswer) {
        event.provide(feedback: feedback)
        feedbackView.setSendButtonEnabled(event.feedbackAnswers.count > 0)
    }
    
    func feedbackCleared(_ feedback: FeedbackQuestion) {
        event.clear(feedback: feedback)
        feedbackView.setSendButtonEnabled(event.feedbackAnswers.count > 0)
    }
    
    func sendFeedbackWasClicked() {
        event.submitFeedback({success in
            
            self.feedbackView.setFeedbackAsSent(success)
            self.feedbackView.setFeedback(questions: self.event.feedbackQuestions,
                answers: self.event.feedbackAnswers,
                isSent: self.event.didSubmitFeedback())
            
            if !success {
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.middle, superView: self.toastView)
                    .show();
            }
            
            self.feedbackView.state = .collapsed
            self.feedbackViewHeightDidChange(self.feedbackView.getHeight())
        })
    }
    
    // MARK: - private methods
    
    private func getImage(_ serverEventId: String) -> UIImage {
        if let eventImage = UIImage(named: "Event_" + serverEventId) {
            return eventImage;
        }
        
        return UIImage(named: "AppBackground")!
    }
    
    private func refreshFavoriteBarIconImage() {
        navigationItem.rightBarButtonItem?.image = event.attending == true ? UIImage(named: "MenuAddedToFavorites") : UIImage(named: "MenuAddToFavorites");
    }
    
    private func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = image.size.height / image.size.width
        let newHeight = newWidth * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func updateAvailableTicketsText(availableTicketsCount: Int) {
        
        if (availableTicketsCount == 0) {
            availableTickets.font = UIFont.boldSystemFont(ofSize: 15)
            availableTickets.textColor = Colors.textColor
        } else {
            availableTickets.font = UIFont.systemFont(ofSize: 15)
            availableTickets.textColor = Colors.textColor
        }
        
        availableTickets.text = String(
            format: "%@. %@",
            getFormattedNumberOfTickets(availableTicketsCount),
            event.availableTicketsLastModified == nil ? "" : "עודכן: " + event.availableTicketsLastModified!.format(getAvailableTicketsLastModifiedFormet(event.availableTicketsLastModified!)))
    }
    
    private func getAvailableTicketsLastModifiedFormet(_ date: Date) -> String {
        return date.clearTimeComponent().timeIntervalSince1970 == Date.now().clearTimeComponent().timeIntervalSince1970 ? "HH:mm" : "HH:mm dd.MM.yyyy"
    }
    
    private func getFormattedNumberOfTickets(_ availableTicketsCount: Int) -> String {
        // Not showing the exact amount of tickets since this info might be in-accurate, and we don't
        // want to confuse people about the exact amount of available tickets.
        switch availableTicketsCount {
        case 0:
            return "אזלו הכרטיסים"
        case 1..<10:
            return "נותרו כרטיסים אחרונים"
        case 10..<30:
            return "נותרו מעט כרטיסים"
        default:
            return "יש כרטיסים"
        }
    }
    
    private func getEventTypeDisclamer() -> String {
        switch event.type.presentation.mode {
        case .Physical:
            return "האירוע יועבר באופן פיזי בלבד."
        case .Virtual:
            return "האירוע יועבר באופן וירטואלי בלבד."
        case .Hybrid:
            return event.type.presentation.location == .Indoors
                ? "האירוע יועבר באופן פיזי ובנוסף לכך ישודר בשידור חי לאתר השידורים."
                : "האירוע יועבר באופן וירטואלי, ובנוסף לכך יוקרן באולם במתחם הפיזי. הכניסה לאולם ההקרנה מותנית ברכישת כרטיס ככל אירוע פיזי אחר."
        }
    }
}
