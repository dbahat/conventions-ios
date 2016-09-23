//
//  EventListHeaderView.swift
//  Conventions
//
//  Created by David Bahat on 2/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var containerView: CardView!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = Colors.eventTimeHeaderColor
    }
}
