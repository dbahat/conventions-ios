//
//  EventViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventViewController: BaseViewController, FeedbackViewProtocol, UIWebViewDelegate {

    var event: ConventionEvent!
    var feedbackViewOpen: Bool = false
    
    @IBOutlet fileprivate weak var eventTitleBoxBoarderView: UIView!
    @IBOutlet fileprivate weak var lecturer: UILabel!
    @IBOutlet fileprivate weak var eventTitle: UILabel!
    @IBOutlet fileprivate weak var eventTypeAndCategory: UILabel!
    @IBOutlet fileprivate weak var hall: UILabel!
    @IBOutlet fileprivate weak var time: UILabel!
    @IBOutlet fileprivate weak var tags: UILabel!
    @IBOutlet fileprivate weak var prices: UILabel!
    @IBOutlet fileprivate weak var titleAndEventTypeContainer: UIView!
    @IBOutlet fileprivate weak var lecturerContainer: UIView!
    @IBOutlet fileprivate weak var metadataContainer: UIView!
    
    @IBOutlet fileprivate weak var refreshAvailableTicketsButton: UIImageView!
    @IBOutlet fileprivate weak var eventDescriptionWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var eventDescriptionWebView: StaticContentWebView!
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
            
            feedbackView.delegate = self
            feedbackView.setFeedback(questions: event.feedbackQuestions,
                                     answers: event.feedbackAnswers,
                                     isSent: event.didSubmitFeedback())
            feedbackView.textColor = Colors.eventFeedbackTextColor
            feedbackView.buttonColor = Colors.feedbackButtonColorEvent
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
        
        lecturer.textColor = Colors.textColor
        eventTitle.textColor = Colors.eventTitleTextColor
        eventTypeAndCategory.textColor = Colors.eventTitleTextColor
        hall.textColor = Colors.textColor
        time.textColor = Colors.textColor
        prices.textColor = Colors.textColor
        tags.textColor = Colors.textColor
        
        
        titleAndEventTypeContainer.backgroundColor = Colors.eventTitleBackground
        eventTitleBoxBoarderView.backgroundColor = Colors.eventTitleBoarderColor
        lecturerContainer.backgroundColor = Colors.eventDetailsBoxColor
        metadataContainer.backgroundColor = Colors.eventDetailsBoxColor
        
        feedbackView.event = event
        lecturer.text = event.lecturer
        eventTitle.text = event.title
        eventTypeAndCategory.text =  event.category.isEmpty
            ? event.type.description : event.category + " - " + event.type.description
        hall.text = event.hall.name
        
        time.text = event.startTime.format("EEE dd.MM") + ", " + event.startTime.format("HH:mm") + " - " + event.endTime.format("HH:mm")
        time.font = UIFont.boldSystemFont(ofSize: 15)
        
        prices.text = String(format: "%d ש״ח, תעריף עמותות מארגנות: %d ש״ח", event.price, event.price > 10 ? event.price - 10 : 0)
        tags.text = "תגיות: " + event.tags.joined(separator: ", ")
        
        if let availableTicketsCount = event.availableTickets, availableTicketsCount >= 0 {
            updateAvailableTicketsText(availableTicketsCount: availableTicketsCount)
        } else {
            availableTickets.removeFromSuperview()
            refreshAvailableTicketsButton.removeFromSuperview()
        }
        
        navigationItem.title = event.type.description
        
        eventDescriptionContainer.isHidden = event.description == ""
        eventDescriptionContainer.backgroundColor = Colors.eventDetailsBoxColor
        
        eventDescriptionWebView.isOpaque = false
        eventDescriptionWebView.delegate = self
        eventDescriptionWebView.scrollView.isScrollEnabled = false
        
        if let eventDescription = event.description {
            eventDescriptionWebView.setContent(eventDescription, color: "#000000")
        }
        
        refreshFavoriteBarIconImage()
        
        refreshAvailableTicketsButton.image = UIImage(named: "MenuUpdates")?.withRenderingMode(.alwaysTemplate)
        refreshAvailableTicketsButton.tintColor = Colors.textColor
        
        if event.directWatchAvailable && event.isEventAvailable() {
            OpenEventContainerHeightConstraint.constant = 50
            openEventLabel.textColor = Colors.textColor
            OpenEventButton.setTitleColor(Colors.buttonColor, for: .normal)
            OpenEventButton.setTitleColor(Colors.buttonPressedColor, for: .selected)
            openEventConatiner.backgroundColor = Colors.eventOpenEventConatinerColor
        } else {
            OpenEventContainerHeightConstraint.constant = 0
            openEventLabel.isHidden = true
            OpenEventButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Convention.instance.eventsInputs.save()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        // Disabled for this convention (as it's not needed)
        //fadeInBackgroundImage()
    }
    
    private func fadeInBackgroundImage() {
        // Loading the image only during viewDidAppear so as not to cause a delay when the ViewController
        // is opened when an event has a "heavy" image.
        let eventImage = getImage(String(event.serverId));
        
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        image.image = resizeImage(eventImage, newWidth: self.view.frame.width);
        
        // Fade in the image
        image.alpha = 0;
        UIView.animate(withDuration: 0.3, animations: {
            self.image.alpha = 1;
            
            // Extract the dominent color from the image and set it as the background
            self.view.backgroundColor = (CCColorCube().extractColors(from: eventImage, flags: 0)[0] as! UIColor);
        });
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        //image.image = resizeImage(getImage(String(event.serverId)), newWidth: size.width);
        
        // Re-evaluate the description, so the webView will resize
        if let eventDescription = event.description {
            eventDescriptionWebView.setContent(eventDescription)
        }
    }
    
    @IBAction func changeFavoriteStateClicked(_ sender: UIBarButtonItem) {
        event.attending = !event.attending;
        
        refreshFavoriteBarIconImage();
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.short, superView: view)
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
        UIApplication.shared.openURL(url)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Reset the webView before calling sizeToFit(), which will only increase it's size
        webView.frame.size.height = 1.0
        webView.sizeToFit()
        
        // Update the height constraint so the rest of the layout will also align to the new height
        eventDescriptionWebViewHeightConstraint.constant = webView.frame.size.height
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == UIWebView.NavigationType.linkClicked {
            
            guard let url = request.url else {
                return true;
            }
            
            // In case the URL clicked points to another event, navigate to it in the App instead of
            // in a browser
            if let eventToNavigateTo = Convention.instance.events.getAll().filter({event in
                // Comparing paths and not the full URLs, since the host portion differs due to redirects
                event.url.path == url.path
            }).first {
                if let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? EventViewController {
                    eventVc.event = eventToNavigateTo
                    navigationController?.pushViewController(eventVc, animated: true)
                    return false
                }
            }
            
            UIApplication.shared.openURL(url)
            return false
        }
        return true
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
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.middle, superView: self.view)
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
            availableTickets.textColor = Colors.eventDetailsHighlightedTextColor
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
}
