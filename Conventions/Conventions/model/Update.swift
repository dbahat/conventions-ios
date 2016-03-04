//
//  Update.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Update {
    var id: String;
    var text: String;
    var date: NSDate;
    var isNew = false;
    
    init(id: String, text: String, date: NSDate) {
        self.id = id;
        self.text = text;
        self.date = date;
    }
}