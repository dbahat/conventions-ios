//
//  EventView.swift
//  Conventions
//
//  Created by David Bahat on 2/21/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

protocol EventStateProtocol : class {
    func changeFavoriteStateWasClicked(_ caller: EventView);
}

class EventView: UIView {

    @IBOutlet fileprivate weak var startTime: UILabel!
    @IBOutlet fileprivate weak var endTime: UILabel!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet fileprivate weak var hallName: UILabel!
    @IBOutlet fileprivate weak var lecturer: UILabel!
    @IBOutlet fileprivate weak var timeLayout: UIView!
    @IBOutlet fileprivate weak var favoriteButton: UIButton!
    @IBOutlet fileprivate weak var feedbackIcon: UIImageView!
    @IBOutlet fileprivate weak var feedbackContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var titleAndDetailsContainer: UIView!
    weak var delegate: EventStateProtocol?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed(String(describing: EventView.self), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        
        // Allow dynamic changing of the favorite button color
        favoriteButton.imageView?.image = favoriteButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        
        addSubview(view);
    }
    

    @IBAction func changeFavoriteStateButtonWasClicked(_ sender: UIButton) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(_ event : ConventionEvent) {
        startTime.text = event.startTime.format("HH:mm");
        endTime.text = event.endTime.format("HH:mm");
        title.text = event.title;
        lecturer.text = event.lecturer;
        hallName.text = event.hall.name;
        timeLayout.backgroundColor = event.color;
        favoriteButton.imageView?.tintColor = event.attending == true ? Colors.eventMarkedAsFavorite : UIColor.black
        
        if let textColor = event.textColor {
            startTime.textColor = textColor;
            endTime.textColor = textColor;
        }
        
        let currentTime = Date()
        if event.endTime.timeIntervalSince1970 < currentTime.timeIntervalSince1970 {
            titleAndDetailsContainer.backgroundColor = Colors.eventEndedColor
        } else if event.startTime.timeIntervalSince1970 <= currentTime.timeIntervalSince1970 {
            titleAndDetailsContainer.backgroundColor = Colors.eventRunningColor
        } else {
            titleAndDetailsContainer.backgroundColor = Colors.eventNotStartedColor
        }
        
        if event.canFillFeedback() {
            feedbackIcon.isHidden = false
            feedbackContainerWidthConstraint.constant = 26
            
            if event.didSubmitFeedback() {
                feedbackIcon.image = event.feedbackAnswers.getFeedbackWeightedRating()?.answer.getImage()
                    ?? UIImage(named: "Feedback_icon_yellow")
            } else {
                
                let imageName = event.feedbackAnswers.count > 0 && !Convention.instance.isFeedbackSendingTimeOver()
                        ? "Feedback_email" // Mail icon to indicate the feedback is pending submission
                        : "Feedback_icon"
                feedbackIcon.image = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                
                feedbackIcon.tintColor = event.attending || event.feedbackAnswers.count > 0
                    ? Colors.eventUserNeedsToCompleteFeecbackButtonColor
                    : UIColor.gray
            }
            
        } else {
            feedbackIcon.isHidden = true
            feedbackContainerWidthConstraint.constant = 0
        }
    }

}
