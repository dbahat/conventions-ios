//
//  EventTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

protocol EventCellStateProtocol : class {
    func changeFavoriteStateWasClicked(_ caller: EventTableViewCell);
}

open class EventTableViewCell: UITableViewCell, EventStateProtocol {

    @IBOutlet fileprivate weak var eventView: EventView!
    weak var delegate: EventCellStateProtocol?;
    
    func changeFavoriteStateWasClicked(_ caller: EventView) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(_ event : ConventionEvent) {
        eventView.setEvent(event);
        eventView.delegate = self;
    }
}
