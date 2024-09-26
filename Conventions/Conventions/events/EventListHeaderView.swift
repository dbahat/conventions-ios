//
//  EventListHeaderView.swift
//  Conventions
//
//  Created by David Bahat on 2/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = Colors.eventTimeHeaderColor
        time.textColor = Colors.eventTimeHeaderTextColor
        time.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.backgroundView?.layer.cornerRadius = 4
    }
}
