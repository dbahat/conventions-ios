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
    
    var halls: Array<Hall>?;
    var events: Array<ConventionEvent>!;
    var favoriteEvents: Array<ConventionEvent>! {
        get {
            return events.filter {
                (event) in event.attending
            }
        }
    }
    
    init() {
        NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(NSDateComponents());
        events = [
            ConventionEvent(
                id: "1",
                serverId: 1,
                color: 123,
                title: "גיבורי ההיסטוריה היפנית ויצוגם באנימה",
                lecturer: "שרון טורנר",
                startTime: NSDate(),
                endTime: NSDate(),
                type: EventType(),
                hall: Hall(name: "אשכול 1"),
                description: "Desc1"),
            ConventionEvent(
                id: "2",
                serverId: 2,
                color: 123,
                title: "חיי בית ספר ביפן: אנימה מול מציאות",
                lecturer: "אמנון לוי",
                startTime: NSDate(),
                endTime: NSDate(),
                type: EventType(),
                hall: Hall(name: "אשכול 2"),
                description: "Desc2"),
            ConventionEvent(
                id: "3",
                serverId: 2,
                color: 123,
                title: "אירוע פתיחה ותחרות האמא'ידול",
                lecturer: "",
                startTime: NSDate(),
                endTime: NSDate(),
                type: EventType(),
                hall: Hall(name: "אולם ראשי"),
                description: "Desc2")
        ]
    }
}

