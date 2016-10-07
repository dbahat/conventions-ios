//
//  EventView.swift
//  Conventions
//
//  Created by David Bahat on 2/21/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

protocol EventStateProtocol : class {
    func changeFavoriteStateWasClicked(caller: EventView);
}

class EventView: UIView {

    @IBOutlet private weak var startTime: UILabel!
    @IBOutlet private weak var endTime: UILabel!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var hallName: UILabel!
    @IBOutlet private weak var lecturer: UILabel!
    @IBOutlet private weak var timeLayout: UIView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var feedbackIcon: UIImageView!
    @IBOutlet private weak var feedbackContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var titleAndDetailsContainer: UIView!
    weak var delegate: EventStateProtocol?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = NSBundle.mainBundle().loadNibNamed(String(EventView), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
    }
    

    @IBAction func changeFavoriteStateButtonWasClicked(sender: UITapGestureRecognizer) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(event : ConventionEvent) {
        startTime.text = event.startTime.format("HH:mm");
        endTime.text = event.endTime.format("HH:mm");
        title.text = event.title;
        lecturer.text = event.lecturer;
        hallName.text = event.hall.name;
        timeLayout.backgroundColor = event.color;
        
        let favoriteImage = event.attending == true ? UIImage(named: "EventAttending") : UIImage(named: "EventNotAttending");
        favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal);
        
        if let textColor = event.textColor {
            startTime.textColor = textColor;
            endTime.textColor = textColor;
        }
        
        let currentTime = NSDate()
        if event.endTime.timeIntervalSince1970 < currentTime.timeIntervalSince1970 {
            titleAndDetailsContainer.backgroundColor = Colors.eventEndedColor
        } else if event.startTime.timeIntervalSince1970 <= currentTime.timeIntervalSince1970 {
            titleAndDetailsContainer.backgroundColor = Colors.eventRunningColor
        } else {
            titleAndDetailsContainer.backgroundColor = Colors.eventNotStartedColor
        }
        
        if event.canFillFeedback() {
            feedbackIcon.hidden = false
            feedbackContainerWidthConstraint.constant = 26
            
            if event.didSubmitFeedback() {
                feedbackIcon.image = event.feedbackAnswers.getFeedbackWeightedRating()?.answer.getImage()
                    ?? UIImage(named: "Feedback_icon_yellow")
            } else {
                
                let imageName = event.feedbackAnswers.count > 0 && !Convention.instance.isFeedbackSendingTimeOver()
                        ? "Feedback_email" // Mail icon to indicate the feedback is pending submission
                        : "Feedback_icon"
                feedbackIcon.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                
                feedbackIcon.tintColor = event.attending || event.feedbackAnswers.count > 0
                    ? Colors.colorAccent // mark that the user needs to complete the feedback
                    : UIColor.grayColor()
            }
            
        } else {
            feedbackIcon.hidden = true
            feedbackContainerWidthConstraint.constant = 0
        }
    }

}
