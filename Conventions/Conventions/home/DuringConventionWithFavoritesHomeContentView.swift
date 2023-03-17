//
//  DuringConventionWithFavoritesHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 19/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class DuringConventionWithFavoritesHomeContentView : UIView {
    
    @IBOutlet weak var currentEventContainer: UIView!
    @IBOutlet weak var currentEventContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var currentEventHeader: UIView!
    @IBOutlet weak var currentEventHeaderTitle: UILabel!
    @IBOutlet weak var currentEventTitle: UILabel!
    @IBOutlet weak var currentEventHall: UILabel!
    @IBOutlet weak var currentEventImage: UIImageView!
    @IBOutlet weak var currentEventImageWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var upcomingEventContainer: UIView!
    @IBOutlet weak var upcomingEventHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingEventHeader: UIView!
    @IBOutlet weak var upcomingEventHeaderTitle: UILabel!
    @IBOutlet weak var upcomingEventTitle: UILabel!
    @IBOutlet weak var upcomingEventHall: UILabel!
    @IBOutlet weak var upcomingEventTime: UILabel!
    @IBOutlet weak var upcomingEventImage: UIImageView!
    @IBOutlet weak var upcomingEventImageWidth: NSLayoutConstraint!
    
    @IBOutlet private weak var goToMyEventsButton: UIButton!
    
    var currentFavoriteEvent: ConventionEvent? {
        didSet {
            if let event = currentFavoriteEvent {
                setVisible(currentEventContainerHeight, visible: true)
                currentEventTitle.text = event.title
                currentEventHall.text = event.hall.name
                setVisible(currentEventImageWidth, visible: event.directWatchAvailable)
                currentEventContainer.isHidden = false
            } else {
                setVisible(currentEventContainerHeight, visible: false)
                currentEventContainer.isHidden = true
            }
        }
    }
    
    private func setVisible(_ height: NSLayoutConstraint, visible: Bool) {
        height.isActive = !visible
        if !visible {
            height.constant = 0
        }
    }
    
    var upcomingFavoriteEvent: ConventionEvent? {
        didSet {
            if let event = upcomingFavoriteEvent {
                setVisible(upcomingEventHeight, visible: true)
                setVisible(upcomingEventImageWidth, visible: event.directWatchAvailable)

                upcomingEventTime.text = String(format: "%@בשעה %@"
                    , isToday(event: event) ? "" : "ב" + event.startTime.format("EEE") + " "
                    , event.startTime.format("HH:mm"))
                upcomingEventTitle.text = event.title
                upcomingEventHall.text = event.hall.name
                upcomingEventContainer.isHidden = false
            } else {
                setVisible(upcomingEventHeight, visible: false)
                upcomingEventContainer.isHidden = true
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
        
        goToMyEventsButton.backgroundColor = Colors.homeButtonsColor

        currentEventContainer.layer.borderWidth = 1
        currentEventContainer.layer.borderColor = Colors.black.cgColor
        currentEventContainer.backgroundColor = Colors.olamot2023_yellow
        upcomingEventContainer.layer.borderWidth = 1
        upcomingEventContainer.layer.borderColor = Colors.black.cgColor
        upcomingEventContainer.backgroundColor = Colors.olamot2023_green
        
        goToMyEventsButton.setTitleColor(Colors.homeButtonsTextColor, for: .normal)
        
        currentEventTitle.textColor = Colors.textColor
        currentEventHall.textColor = Colors.textColor
        currentEventImage.image = UIImage(named: "HomeOnlineEvent")?.withRenderingMode(.alwaysTemplate)
        currentEventImage.tintColor = Colors.black
        upcomingEventImage.image = UIImage(named: "HomeOnlineEvent")?.withRenderingMode(.alwaysTemplate)
        upcomingEventImage.tintColor = Colors.black
        
        upcomingEventTime.textColor = Colors.textColor
        upcomingEventHall.textColor = Colors.textColor
        upcomingEventTitle.textColor = Colors.textColor
        
        currentEventHeaderTitle.textColor = Colors.olamot2023_yellow
        upcomingEventHeaderTitle.textColor = Colors.olamot2023_green
        
        currentEventHeader.backgroundColor = Colors.black
        upcomingEventHeader.backgroundColor = Colors.black
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
