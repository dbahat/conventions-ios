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
    func parse(data data:NSData!) -> Array<ConventionEvent>! {
        return parse(data: data, halls: Convention.instance.halls);
    }
    
    func parse(data data: NSData!, halls: Array<Hall>!) -> Array<ConventionEvent>! {
        var result = Array<ConventionEvent>();
        
        // Note -
        // Some events are defined as "special events", meaning they share a common description.
        // For these event types, the server returns an extra parameter timetable-url-pid, which contains
        // the id of the event containing the description.
        //
        // To parse special event, we keep a maps of special events to the eventId containing the special 
        // event content, and another map from eventId to it's description.
        // After all events were parsed, we can follow the internal link in timetable-url-pid to get the
        // special event description.
        var specialEvents = Dictionary<Int, Array<ConventionEvent>>();
        var eventIdToDescription = Dictionary<Int, String>();
        
        guard let deserializedEvents = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray else {
            print("Failed to deserialize cached events");
            return result;
        }
        
        guard let events = deserializedEvents else {
            print("Failed to deserialize cached events");
            return result;
        }
        
        for event in events {
            guard let eventId = event["ID"] as? Int else {
                print("Got event without ID. Skipping");
                continue;
            }
            
            guard var description = event["content"] as? String else {
                print("Event missing description. Skipping. ID=", eventId);
                continue;
            }
            
            guard let internalEvents = event["timetable-info"] as? Array<NSDictionary> else {
                continue;
            }
            
            // Keep the event description. Needed for special events.
            eventIdToDescription[eventId] = description;
            
            // Each event can appear in multiple times (e.g. event Kareoke can be in both 12:00 
            // and 18:00). For simplicity, we treat it as multiple events.
            var internalEventNumber = 1;
            for internalEvent in internalEvents {
                if (internalEvent["tooltip"] as! String? == "hidden") {
                    print("Skipping hidden event ", eventId);
                    continue;
                }
                
                var color: UIColor?;
                if let colorCode = event["timetable-bg"] as? String {
                    color = UIColor(hexString: colorCode);
                }
                var textColor: UIColor?;
                if let colorCode = event["timetable-text-color"] as? String {
                    textColor = UIColor(hexString: "#" + colorCode);
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
                
                if let ignoreDescription = event["timetable-disable-url"] as? String {
                    if (ignoreDescription == "1") {
                        // Some events have temporary description and are not clickable in the website.
                        // Don't show description for these types of events.
                        description = "";
                    }
                }
                
                let conventionEvent = ConventionEvent(
                    // Since we duplicate events that appear in multiple times, compose a new
                    // unique id from the server event id and it's internal index.
                    // e.g. if event 100 appears in 12:00 and 17:00, it's ids will be 100_1 and 100_2
                    id: String(format: "%d_%d", arguments: [eventId, internalEventNumber]),
                    serverId: eventId,
                    color: color,
                    textColor: textColor,
                    title: event["title"] as? String,
                    lecturer: internalEvent["before_hour_text"] as? String,
                    startTime: appendTimeToConventionDate(startTime),
                    endTime: appendTimeToConventionDate(endTime),
                    type: EventType(
                        backgroundColor: color,
                        description: event["categories-text"]??["name"] as? String),
                    hall: halls.filter({hall in hall.name == hallName}).first,
                    description: parseEventDescription(description));
                
                result.append(conventionEvent);
                internalEventNumber++;
                
                // In case the event is a speical event, add it to the map
                if let specialEventId = event["timetable-url-pid"] as? Int {
                    if specialEventId != 0 {
                        if (specialEvents[specialEventId] == nil) {
                            specialEvents[specialEventId] = [conventionEvent];
                        } else {
                            specialEvents[specialEventId]?.append(conventionEvent);
                        }
                    }
                }
            }
        }
        
        // Go over all the speical events and map them to their linked description
        for specialEvent in specialEvents {
            for event in specialEvent.1 {
                event.description = parseEventDescription(eventIdToDescription[specialEvent.0]);
            }
        }
        
        return result;
    }

    func appendTimeToConventionDate(time: String!) -> NSDate! {
        let dateAndTime = Convention.date.format("yyyy:MM:dd") + " " + time;
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

