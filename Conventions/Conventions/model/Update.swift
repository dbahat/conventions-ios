//
//  Update.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Update {
    var id: String = "";
    var text: String = "";
    var date: NSDate = NSDate();
    var isNew = true;
    
    init(id: String, text: String, date: NSDate) {
        self.id = id;
        self.text = text;
        self.date = date;
    }
    
    init?(json: Dictionary<String, AnyObject>) {
        guard let id = json["id"] as? String else {return nil}
        guard let text = json["text"] as? String else {return nil}
        guard let date = json["date"] as? NSTimeInterval else {return nil}
        guard let isNew = json["isNew"] as? Bool else {return nil}
        
        self.id = id;
        self.text = text;
        self.date = NSDate(timeIntervalSince1970: date);
        self.isNew = isNew;
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        return ["id": id, "text": text, "date": date.timeIntervalSince1970, "isNew": isNew];
    }
}