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
    
    weak var delegate: EventStateProtocol?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = NSBundle.mainBundle().loadNibNamed("EventView", owner: self, options: nil)[0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
    }
    
    @IBAction func changeFavoriteStateButtonWasClicked(sender: UIButton) {
        delegate?.changeFavoriteStateWasClicked(self);
    }
    
    func setEvent(event : ConventionEvent) {
        startTime.text = event.startTime!.format("HH:mm");
        endTime.text = event.endTime!.format("HH:mm");
        title.text = event.title;
        lecturer.text = event.lecturer;
        hallName.text = event.hall?.name;
        timeLayout.backgroundColor = event.color;
        
        let favoriteImage = event.attending == true ? UIImage(named: "EventAttending") : UIImage(named: "EventNotAttending");
        favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal);
    }

}
