//
//  Convention.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Convention {
    private static let eventsCacheFileName = NSHomeDirectory() + "/Library/Caches/CamiEvents.json";
    
    static let instance = Convention();
    static let date = NSDate.from(year: 2016, month: 3, day: 23);
    
    var halls: Array<Hall>;
    var events: Array<ConventionEvent> = [];
    var updates: Array<Update> = [];
    let userInputs = UserInputs();
    
    init() {
        halls = [
            Hall(name: "אולם ראשי", order: 1),
            Hall(name: "אודיטוריום שוורץ", order: 2),
            Hall(name: "אשכול 1", order: 3),
            Hall(name: "אשכול 2", order: 4),
            Hall(name: "אשכול 3", order: 5),
            Hall(name: "משחקייה", order: 6),
            Hall(name: "אירועים מיוחדים", order: 7)
        ];
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        if let cachedEvents = NSData(contentsOfFile: Convention.eventsCacheFileName) {
            events = EventsParser().parse(data: cachedEvents, halls: halls);
            print("Events from cache: ", events.count);
        } else if let preInstalledEvents = NSData(contentsOfFile: resourcePath + "/CamiEvents.json") {
            events = EventsParser().parse(data: preInstalledEvents, halls: halls);
            print("Preinstalled events: ", events.count);
        }
    }
    
    func findHallByName(name: String!) -> Hall! {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall;
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: "אירועים מיוחדים", order: 6);
    }
    
    func refresh(callback: (() -> Void)?) {
        EventsDownloader().download({(result) in
            guard let events = result else {
                return;
            }
            
            result?.writeToFile(Convention.eventsCacheFileName, atomically: true);
            
            // Using main thread for syncronizing access to events
            dispatch_async(dispatch_get_main_queue()) {
                Convention.instance.events = EventsParser().parse(data: events);
                print("Downloaded events: ", Convention.instance.events.count);
                callback?();
            }
        });
    }
}

