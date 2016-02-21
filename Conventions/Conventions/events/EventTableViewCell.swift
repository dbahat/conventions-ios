//
//  EventTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

protocol EventCellStateProtocol : class {
    func changeFavoriteStateWasClicked(caller: EventTableViewCell);
}

public class EventTableViewCell: UITableViewCell, EventStateProtocol {

    @IBOutlet private weak var eventView: EventView!
    weak var delegate: EventCellStateProtocol?;
    
    func changeFavoriteStateWasClicked(caller: EventView) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(event : ConventionEvent) {
        eventView.setEvent(event);
        eventView.delegate = self;
    }
}
