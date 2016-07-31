//
//  TableAnswerCell.swift
//  Conventions
//
//  Created by David Bahat on 7/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class TableAnswerCell : UITableViewCell {
    
    @IBOutlet private weak var answerLabel: UILabel!
    
    var answer: String? {
        didSet {
            answerLabel.text = answer
        }
    }
    
    override var selected: Bool {
        didSet {
            // Hide the accessoryView by setting the cell tint color to clear (not setting the 
            // accessory to None since we want the text indented to it's size)
            tintColor = selected ? UIColor(hexString: "#f55368") : UIColor.clearColor()
            answerLabel.textColor = selected ? UIColor(hexString: "#f55368") : UIColor(hexString: "#b92136")
        }
    }
}