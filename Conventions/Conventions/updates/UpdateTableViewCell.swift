//
//  UpdateTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdateTableViewCell: UITableViewCell {
    @IBOutlet fileprivate weak var message: UITextView!
    @IBOutlet fileprivate weak var title: UILabel!
    
    func setUpdate(_ update: Update) {
        title.text = update.date.format("HH:mm dd.MM.yyyy")
        message.text = update.text
        
        message.backgroundColor = update.isNew
            ? UIColor.clear : UIColor.clear
    }
}
