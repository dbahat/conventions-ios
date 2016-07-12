//
//  Convention.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Convention {
    static let instance = Convention();
    static let date = NSDate.from(year: 2016, month: 7, day: 11);
    static let name = "Harucon2016";
    static let mailbox = "dbahat@live.com"
    
    var halls: Array<Hall>;
    var events: Events;
    var updates = Updates();
    let userInputs = UserInputs();
    
    init() {
        halls = [
            Hall(name: "אולם ראשי", order: 1),
            Hall(name: "אודיטוריום שוורץ", order: 2),
            Hall(name: "אשכול 1", order: 3),
            Hall(name: "אשכול 2", order: 4),
            Hall(name: "אשכול 3", order: 5)
        ];
        
        events = Events(halls: halls);
    }
    
    func findHallByName(name: String!) -> Hall! {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall;
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: "אירועים מיוחדים", order: 6);
    }
    
    func isFeedbackSendingTimeOver() -> Bool {
        // Check if the event will end in 15 minutes or less
        return NSDate().compare(Convention.date.addDays(14)) == .OrderedDescending
    }
}

