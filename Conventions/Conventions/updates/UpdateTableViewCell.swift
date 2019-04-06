//
//  UpdateTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdateTableViewCell: UITableViewCell {
    @IBOutlet private weak var message: UITextView!
    @IBOutlet private weak var title: UILabel!
    
    func setUpdate(_ update: Update) {
        title.text = update.date.format("HH:mm dd.MM.yyyy")
        title.textColor = Colors.textColor
        title.backgroundColor = Colors.updateTimeBackground
        
        message.text = update.text
        message.textColor = Colors.textColor
        
        message.backgroundColor = update.isNew ? UIColor.clear : UIColor.clear
    }
}
