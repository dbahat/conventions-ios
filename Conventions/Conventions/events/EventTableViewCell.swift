//
//  EventTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

public protocol EventStateProtocol : class {
    func changeFavoriteStateWasClicked(caller: EventTableViewCell);
}

public class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var hallName: UILabel!
    @IBOutlet weak var lecturer: UILabel!
    @IBOutlet weak var timeLayout: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: EventStateProtocol?;
    
    @IBAction func changeFavoriteStateButtonWasClicked(sender: UIButton) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(event : ConventionEvent) {
        startTime.text = NSCalendar.currentCalendar().components([.Hour], fromDate: event.startTime!).hour.description + ":00";
        endTime.text = NSCalendar.currentCalendar().components([.Hour], fromDate: event.startTime!).hour.description + ":00";
        title.text = event.title;
        lecturer.text = event.lecturer;
        hallName.text = event.hall?.name;
        timeLayout.backgroundColor = event.color;
        
        let favoriteImage = event.attending ? UIImage(named: "EventAttending") : UIImage(named: "EventNotAttending");
        favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal);
    }
}
