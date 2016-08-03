//
//  EventViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventViewController: BaseViewController, FeedbackViewProtocol, UIWebViewDelegate {

    var event: ConventionEvent!;
    
    @IBOutlet private weak var lecturer: UILabel!
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var hallAndTime: UILabel!

    @IBOutlet private weak var eventDescriptionWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventDescriptionWebView: UIWebView!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var eventDescriptionContainer: UIView!
    @IBOutlet private weak var feedbackView: FeedbackView!
    @IBOutlet private weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event.canFillFeedback() {
            feedbackView.delegate = self
            feedbackView.setFeedback(questions: event.feedbackQuestions,
                                     answers: event.feedbackAnswers,
                                     isSent: event.didSubmitFeedback())
            
            if (event.didSubmitFeedback()) {
                feedbackView.state = .Collapsed
            } else if event.attending || event.feedbackAnswers.count > 0 {
                // If the user marked this as favorite or started filling feedback for the event
                feedbackView.state = .Expended
            } else {
                feedbackView.state = .Collapsed
            }
            
            // Need to get the view height only after setting it's collapsed/expanded state
            feedbackViewHeightConstraint.constant = feedbackView.getHeight()
        } else {
            feedbackView.hidden = true
            feedbackViewHeightConstraint.constant = 0
        }
        
        lecturer.text = event.lecturer;
        eventTitle.text = event.title;
        hallAndTime.text = event.hall.name + ", " + event.startTime.format("HH:mm") + " - " + event.endTime.format("HH:mm");
        
        navigationItem.title = event.type?.description;
        
        eventDescriptionContainer.hidden = event.description == "";
        
        eventDescriptionWebView.opaque = false
        eventDescriptionWebView.delegate = self
        eventDescriptionWebView.scrollView.scrollEnabled = false
        
        if let eventDescription = event.description {
            eventDescriptionWebView.loadHTMLString(String(format: "<body style=\"font: -apple-system-body\"><div dir='rtl'>%@</div></body>", eventDescription), baseURL: nil)
        }
        
        refreshFavoriteBarIconImage();
    }
    
    override func viewWillDisappear(animated: Bool) {
        Convention.instance.eventsInputs.save()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // Loading the image only during viewDidAppear so as not to cause a delay when the ViewController
        // is opened when an event has a "heavy" image.
        let eventImage = getImage(String(event.serverId));
        
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        image.image = resizeImage(eventImage, newWidth: self.view.frame.width);
        
        // Fade in the image
        image.alpha = 0;
        UIView.animateWithDuration(0.3, animations: {
            self.image.alpha = 1;
            
            // Extract the dominent color from the image and set it as the background
            self.view.backgroundColor = (CCColorCube().extractColorsFromImage(eventImage, flags: 0)[0] as! UIColor);
        });
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        image.image = resizeImage(getImage(String(event.serverId)), newWidth: size.width);
    }
    
    @IBAction func changeFavoriteStateClicked(sender: UIBarButtonItem) {
        event.attending = !event.attending;
        
        refreshFavoriteBarIconImage();
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.Short, superView: view)
            .show();
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.sizeToFit()
        eventDescriptionWebViewHeightConstraint.constant = webView.frame.size.height
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    // MARK: - EventFeedbackViewProtocol
    
    func feedbackViewHeightDidChange(newHeight: CGFloat) {
        feedbackViewHeightConstraint.constant = newHeight
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func feedbackProvided(feedback: FeedbackAnswer) {
        event.provide(feedback: feedback)
        feedbackView.setSendButtonEnabled(event.feedbackAnswers.count > 0)
    }
    
    func feedbackCleared(feedback: FeedbackQuestion) {
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
                TTGSnackbar(message: "לא ניתן לשלוח את הפידבק. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Middle, superView: self.view)
                    .show();
            }
            
            self.feedbackView.state = .Collapsed
            self.feedbackViewHeightDidChange(self.feedbackView.getHeight())
        })
    }
    
    // MARK: - private methods
    
    private func getImage(serverEventId: String) -> UIImage {
        if let eventImage = UIImage(named: "Event_" + serverEventId) {
            return eventImage;
        }
        
        return UIImage(named: "Event_Default")!
    }
    
    private func refreshFavoriteBarIconImage() {
        navigationItem.rightBarButtonItem?.image = event.attending == true ? UIImage(named: "MenuAddedToFavorites") : UIImage(named: "MenuAddToFavorites");
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = image.size.height / image.size.width
        let newHeight = newWidth * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}