//
//  DuringConventionWithFavoritesHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 19/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class DuringConventionWithFavoritesHomeContentView : UIView {
    @IBOutlet private weak var currentEventLabel: UILabel!
    @IBOutlet private weak var upcomingEventTimeLabel: UILabel!
    @IBOutlet private weak var upcomingEventNameLabel: UILabel!
    @IBOutlet private weak var upcomingEventHallLabel: UILabel!
    @IBOutlet private weak var myEventsTitleLabel: UILabel!
    @IBOutlet private weak var goToMyEventsButton: UIButton!
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var currentEventContainer: UIView!
    @IBOutlet private weak var nextEventContainer: UIView!
    
    // keeping strong references to the constraints, since we change their active state dynamiclly, which
    // causes the strong ref kept from the view hirarchy to the constraint to drop.
    @IBOutlet private var currentEventHeightConstraint: NSLayoutConstraint!
    
    var currentFavoriteEvent: ConventionEvent? {
        didSet {
            if let event = currentFavoriteEvent {
                currentEventHeightConstraint.isActive = false
                currentEventLabel.text = "כעת: " + event.title
            } else {
                currentEventHeightConstraint.isActive = true
                currentEventHeightConstraint.constant = 0
            }
        }
    }
    
    var upcomingFavoriteEvent: ConventionEvent? {
        didSet {
            if let event = upcomingFavoriteEvent {
                upcomingEventTimeLabel.text = String(format: "%@בשעה %@"
                    , isToday(event: event) ? "" : "ב" + event.startTime.format("EEE") + " "
                    , event.startTime.format("HH:mm"))
                upcomingEventNameLabel.text = event.title
                upcomingEventHallLabel.text = event.hall.name
            } else {
                if let currentEvent = currentFavoriteEvent {
                    upcomingEventTimeLabel.text = "כעת:"
                    upcomingEventNameLabel.text = currentEvent.title
                    upcomingEventHallLabel.text = currentEvent.hall.name
                    
                    currentEventHeightConstraint.isActive = true
                    currentEventHeightConstraint.constant = 0
                }
            }
        }
    }
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        inflateNib(DuringConventionWithFavoritesHomeContentView.self)
        
        let screenRect = UIScreen.main.bounds

        // Special handling for extra-small devices (e.g. iphone 4, ipad using iphone simulator
        if (screenRect.height <= 480) {
            currentEventLabel.font = UIFont.systemFont(ofSize: 10)
            upcomingEventTimeLabel.font = UIFont.systemFont(ofSize: 10)
            upcomingEventNameLabel.font = UIFont.boldSystemFont(ofSize: 11)
            upcomingEventHallLabel.font = UIFont.systemFont(ofSize: 10)
            myEventsTitleLabel.font = UIFont.systemFont(ofSize: 10)
            goToMyEventsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        } else if (screenRect.width <= 320) {
            // More special handling for iphone 5
            currentEventLabel.font = UIFont.systemFont(ofSize: 15)
            upcomingEventTimeLabel.font = UIFont.systemFont(ofSize: 15)
            upcomingEventNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            upcomingEventHallLabel.font = UIFont.systemFont(ofSize: 15)
            myEventsTitleLabel.font = UIFont.systemFont(ofSize: 15)
            goToMyEventsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        goToMyEventsButton.backgroundColor = Colors.homeButtonsColor
        titleContainer.backgroundColor = Colors.homeTimeBoxContainerColor
        currentEventContainer.backgroundColor = Colors.homeCurrentEventColor
        nextEventContainer.backgroundColor = Colors.homeNextEventColor
        
        goToMyEventsButton.setTitleColor(Colors.homeButtonsTextColor, for: .normal)
        myEventsTitleLabel.textColor = Colors.homeTimeTextColor
        currentEventLabel.textColor = Colors.homeTimeTextColor
        upcomingEventTimeLabel.textColor = Colors.homeMainLabelTextColor
        upcomingEventHallLabel.textColor = Colors.homeMainLabelTextColor
        upcomingEventNameLabel.textColor = Colors.homeMainLabelTextColor
    }
    
    @IBAction func navigateToCurrentEventWasClicked(_ sender: UITapGestureRecognizer) {
        if let event = currentFavoriteEvent {
            delegate?.navigateToEventClicked(event: event)
        }
    }

    @IBAction func navigateToUpcomingEventWasClicked(_ sender: UITapGestureRecognizer) {
        if let event = upcomingFavoriteEvent {
            delegate?.navigateToEventClicked(event: event)
            return
        }
        
        if let currentEvent = currentFavoriteEvent {
            delegate?.navigateToEventClicked(event: currentEvent)
            return
        }
    }
    
    @IBAction func navigateToMyEventsWasClicked(_ sender: UIButton) {
        delegate?.navigateToFavoritesClicked()
    }
    
    private func isToday(event: ConventionEvent) -> Bool {
        return event.startTime.clearTimeComponent().timeIntervalSince1970 == Date.now().clearTimeComponent().timeIntervalSince1970
    }
}
