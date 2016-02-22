//
//  ModelParser.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

class EventsParser {
    func parse(data: NSData!) -> Array<ConventionEvent>? {
        var result = Array<ConventionEvent>();
        
        do {
            if let events = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                for event in events {
                    guard let eventId = event["ID"] as? Int else {
                        print("Got event without ID. Skipping");
                        continue;
                    }
                    
                    // Each event can appear in multiple times. For simplicity, we treat it as multiple
                    // events.
                    var internalEventNumber = 1;
                    guard let internalEvents = event["timetable-info"] as? Array<NSDictionary> else {
                        continue;
                    }
                    for internalEvent in internalEvents {
                        if (internalEvent["tooltip"] as! String? == "hidden") {
                            print("Skipping hidden event ", eventId);
                            continue;
                        }
                        
                        var color: UIColor?;
                        if let colorCode = event["timetable-bg"] as? String {
                            color = UIColor(hexString: colorCode);
                        }
                        
                        guard let startTime = internalEvent["start"] as? String else {
                            print("Event missing startTime. Skipping. ID=", eventId);
                            continue;
                        }
                        guard let endTime = internalEvent["end"] as? String else {
                            print("Event missing endTime. Skipping. ID=", eventId);
                            continue;
                        }
                        guard let hallName = internalEvent["room"] as? String else {
                            print("Event missing room. Skipping. ID=", eventId);
                            continue;
                        }
                        
                        let conventionEvent = ConventionEvent(
                            // Since we duplicate events that appear in multiple times, compose a new
                            // unique id from the server event id and it's internal index.
                            // e.g. if event 100 appears in 12:00 and 17:00, it's ids will be 100_1 and 100_2
                            id: String(format: "%d_%d", arguments: [eventId, internalEventNumber]),
                            serverId: event["ID"] as? Int,
                            color: color,
                            title: event["title"] as? String,
                            lecturer: internalEvent["before_hour_text"] as? String,
                            startTime: appendTimeToConventionDate(startTime),
                            endTime: appendTimeToConventionDate(endTime),
                            type: EventType(
                                backgroundColor: color,
                                description: event["categories-text"]??["name"] as? String),
                            hall: Convention.instance.findHallByName(hallName),
                            description: parseEventDescription(event["content"] as! String?));
                        
                        result.append(conventionEvent);
                        internalEventNumber++;
                        
                        print("Event ", conventionEvent.id, " name ", conventionEvent.title)
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription);
            return nil;
        }
        
        return result;
    }
    
    func appendTimeToConventionDate(time: String!) -> NSDate! {
        let dateAndTime = Convention.instance.date.format("yyyy:MM:dd") + " " + time;
        return NSDate.parse(dateAndTime, dateFormat: "yyyy:MM:dd HH:mm:ss");
    }
    
    func parseEventDescription(eventDescription : String?) -> String? {
        return eventDescription?
            .removeAll(pattern: "class=\"[^\"]*\"")?
            .removeAll(pattern: "style=\"[^\"]*\"")?
            .removeAll(pattern: "width=\"[^\"]*\"")?
            .removeAll(pattern: "height=\"[^\"]*\"")?
            .replace(pattern: "<div", withTemplate: "<xdiv")?
            .replace(pattern: "/div>", withTemplate: "/xdiv")?
            .replace(pattern: "\t", withTemplate: "    ")?
            .replace(pattern: "<img", withTemplate: "<ximg")?
            .replace(pattern: "/img>", withTemplate: "/ximg>");
    }
}

extension String {
    func removeAll(pattern pattern: String?) -> String? {
        return replace(pattern: pattern, withTemplate: "");
    }
    
    func replace(pattern pattern: String?, withTemplate template: String?) -> String? {
        guard let unwrappedPattern = pattern else {
            return pattern;
        }
        guard let unwrappedTemplate = template else {
            return pattern;
        }
        
        let regex = try? NSRegularExpression(pattern: unwrappedPattern, options: NSRegularExpressionOptions.CaseInsensitive);
        
        return regex?.stringByReplacingMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: unwrappedTemplate);
    }
}
