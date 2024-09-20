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
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var isNewLabel: UIView!
    
    func setUpdate(_ update: Update) {
        title.text = update.date.format("HH:mm dd.MM.yyyy")
        title.textColor = Colors.updateTimeTextColor
        title.backgroundColor = Colors.updateTimeBackground
        
        message.text = update.text
        message.textColor = Colors.updateTextColor
        
        container.backgroundColor = Colors.updateBackgroundColor
        container.layer.cornerRadius = 4
        
        isNewLabel.backgroundColor = Colors.icon2024_clay600
        isNewLabel.layer.cornerRadius = 8
        
        isNewLabel.isHidden = !update.isNew
    }
}
