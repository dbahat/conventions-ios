//
//  TableAnswerCell.swift
//  Conventions
//
//  Created by David Bahat on 7/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class TableAnswerCell : UITableViewCell {
    
    @IBOutlet fileprivate weak var answerLabel: UILabel!
    
    var answer: String? {
        didSet {
            answerLabel.text = answer
        }
    }
    
    override var isSelected: Bool {
        didSet {
            // Hide the accessoryView by setting the cell tint color to clear (not setting the 
            // accessory to None since we want the text indented to it's size)
            tintColor = isSelected ? Colors.buttonColor : UIColor.clear
            answerLabel.textColor = isSelected ? Colors.buttonPressedColor : Colors.buttonColor
        }
    }
}
