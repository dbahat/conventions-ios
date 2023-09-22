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

    @IBOutlet private weak var startTime: UILabel!
    @IBOutlet private weak var endTime: UILabel!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var hallName: UILabel!
    @IBOutlet private weak var lecturer: UILabel!
    @IBOutlet private weak var timeLayout: UIView!
    @IBOutlet private weak var favoriteButtonImage: UIImageView!
    @IBOutlet private weak var feedbackIcon: UIImageView!
    @IBOutlet private weak var feedbackContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var seperator: UIView!
    @IBOutlet private weak var standAndEndTimeSeperator: UILabel!
    
    @IBOutlet private weak var titleAndDetailsContainer: UIView!
    weak var delegate: EventStateProtocol?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inflateNib(EventView.self)
        
        titleAndDetailsContainer.layer.cornerRadius = 4
        titleAndDetailsContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        timeLayout.layer.cornerRadius = 4
        timeLayout.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    

    @IBAction func changeFavoriteStateButtonWasClicked(_ sender: UIButton) {
        delegate?.changeFavoriteStateWasClicked(self)
    }
    
    func setEvent(_ event : ConventionEvent) {
        startTime.text = event.startTime.format("HH:mm")
        endTime.text = event.endTime.format("HH:mm")
        title.text = event.title
        lecturer.text = event.lecturer
        hallName.text = event.hall.name

        timeLayout.backgroundColor = calculateEventColor(event: event)
        timeLayout.layer.borderWidth = 0
        timeLayout.layer.borderColor = calculateEventColor(event: event).cgColor
        seperator.backgroundColor = Colors.eventSeperatorColor

        
        // Allow dynamic changing of the favorite button color
        favoriteButtonImage.image = event.attending == true ? UIImage(named: "EventAttending")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "EventNotAttending")?.withRenderingMode(.alwaysTemplate)
        favoriteButtonImage.tintColor = event.attending == true ? Colors.eventMarkedAsFavorite : Colors.eventNotMarkedAsFavorite
        
        if let textColor = event.textColor {
            startTime.textColor = textColor;
            endTime.textColor = textColor;
            standAndEndTimeSeperator.textColor = textColor
        } else {
            let designedAsVirtual = event.type.presentation.designedAsVirtual()
            let eventTimeTextColor = calculateEventTimeTextColor(event: event)
            startTime.textColor = designedAsVirtual ? Colors.eventTimeboxTextColorVirtual : eventTimeTextColor
            endTime.textColor = designedAsVirtual ? Colors.eventTimeboxTextColorVirtual : eventTimeTextColor
            standAndEndTimeSeperator.textColor = designedAsVirtual ? Colors.eventTimeboxTextColorVirtual : eventTimeTextColor
        }
        
        titleAndDetailsContainer.backgroundColor = Colors.eventViewTitleAndDetailsContainerBackground
        
        let dateBasedColor = Colors.eventContentTextColor
        title.textColor = dateBasedColor
        lecturer.textColor = dateBasedColor
        hallName.textColor = dateBasedColor
        
        if event.canFillFeedback() {
            feedbackIcon.isHidden = false
            feedbackContainerWidthConstraint.constant = 26
            
            if event.didSubmitFeedback() {
                feedbackIcon.image = event.feedbackAnswers.getFeedbackWeightedRating()?.answer.getImage()
                    ?? UIImage(named: "Feedback_icon_yellow")
                feedbackIcon.tintColor = Colors.buttonPressedColor
            } else {
                
                let imageName = event.feedbackAnswers.count > 0 && !Convention.instance.isFeedbackSendingTimeOver()
                        ? "Feedback_email" // Mail icon to indicate the feedback is pending submission
                        : "Feedback_icon"
                feedbackIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                
                feedbackIcon.tintColor = event.attending || event.feedbackAnswers.count > 0
                    ? Colors.eventUserNeedsToCompleteFeecbackButtonColor
                    : dateBasedColor
            }
            
        } else {
            feedbackIcon.isHidden = true
            feedbackContainerWidthConstraint.constant = 0
        }
    }
    
    private func calculateEventTimeTextColor(event: ConventionEvent) -> UIColor {
        let currentTime = Date.now()
        if event.endTime.timeIntervalSince1970 < currentTime.timeIntervalSince1970 {
            return Colors.eventNotRunningTimeTextColor
        } else if event.startTime.timeIntervalSince1970 <= currentTime.timeIntervalSince1970 {
            return Colors.eventRunningTimeTextColor
        } else {
            return Colors.eventNotRunningTimeTextColor
        }
    }
    
    private func calculateEventColor(event: ConventionEvent) -> UIColor {
        let currentTime = Date.now()
        if event.endTime.timeIntervalSince1970 < currentTime.timeIntervalSince1970 {
            return Colors.eventEndedColor
        } else if event.startTime.timeIntervalSince1970 <= currentTime.timeIntervalSince1970 {
            return Colors.eventRunningColor
        } else {
            return Colors.eventNotStartedColor
        }
    }

}
