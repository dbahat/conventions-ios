//
//  UpdateTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdateTableViewCell: UITableViewCell {
    @IBOutlet private weak var message: UITextView!
    @IBOutlet weak var title: UILabel!
    
    func setUpdate(update: Update) {
        title.text = update.date.format("dd.MM.yyyy HH:mm");
        message.text = update.text;
    }
}
