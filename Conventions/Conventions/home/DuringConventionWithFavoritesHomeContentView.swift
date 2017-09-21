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
                upcomingEventTimeLabel.text = String(format: "ב%@ בשעה %@"
                    , event.startTime.format("EEE")
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
        inflateNib(DuringConventionWithFavoritesHomeContentView.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inflateNib(DuringConventionNoFavoritesHomeContentView.self)
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
}
