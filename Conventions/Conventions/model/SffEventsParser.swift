//
//  SffModelParser.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

class SffEventsParser {
    func parse(data: Data) -> Array<ConventionEvent>! {
        var result = Array<ConventionEvent>();
        
        guard let deserializedEvents =
            ((try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray) as NSArray??),
            let events = deserializedEvents
        else {
            print("Failed to deserialize events");
            return result;
        }
        
        for rawEvent in events {
            guard let event = rawEvent as? Dictionary<String, AnyObject> else {
                print("Got invalid event. Skipping");
                continue;
            }
            
            guard let eventId = event["id"] as? String else {
                print("Got event without ID. Skipping");
                continue;
            }
            guard let eventType = event["track"] as? String else {
                print("Got event without type. Skipping. ID=", eventId);
                continue;
            }
            guard let title = event["title"] as? String else {
                print("Event missing title. Skipping. ID=", eventId);
                continue;
            }
            guard let description = event["description"] as? String else {
                print("Event missing description. Skipping. ID=", eventId);
                continue;
            }
            guard let startTime = event["time"]?["start"] as? String else {
                print("Event missing startTime. Skipping. ID=", eventId);
                continue;
            }
            guard let endTime = event["time"]?["end"] as? String else {
                print("Event missing endTime. Skipping. ID=", eventId);
                continue;
            }
            guard
                let hallName = event["location"] as? String else {
                print("Event missing location. Skipping. ID=", eventId, " name=", title);
                continue;
            }
            guard
                let presentation = parsePresentation(event) else {
                print("Event missing virtual/physical properties. Skipping. ID=", eventId, " name=", title);
                continue;
            }
            
            var eventPrice = 0
            if let price = event["price"] as? String,
                let intPrice = Int(price) {
                eventPrice = intPrice
            }
            
            var speaker = ""
            if let speakers = event["speakers"] as? NSArray {
                speaker = speakers.count > 0 ? speakers.componentsJoined(by: ",") : ""
            }
            
            
            let conventionEvent = ConventionEvent(
                id: eventId,
                serverId: Int(eventId) ?? 0,
                color: Colors.eventTimeDefaultBackgroundColor,
                textColor: nil,
                title: title.stringByDecodingHTMLEntities,
                lecturer: speaker.stringByDecodingHTMLEntities,
                startTime: parseDate(startTime),
                endTime: parseDate(endTime),
                type: EventType(
                    backgroundColor: nil,
                    description: eventType,
                    presentation: presentation
                ),
                hall: Convention.instance.findHallByName(hallName),
                description: parseEventDescription(description),
                category: "", // Optional parameter. Kept in the ctor for backwards compatability.
                price: eventPrice,
                tags: [],
                url: URL(string: (event["url"] as? String)!)!)
            
            if let availableTickets = event["available_tickets"] as? String {
                conventionEvent.availableTickets = Int(availableTickets)
            }
            if let category = event["categories"]?.firstObject as? String {
                conventionEvent.category = category
            }
            if let tags = event["tags"] as? Array<String> {
                conventionEvent.tags = tags
            }
            
            result.append(conventionEvent)
            
        }
        
        return result;
    }
    
    private func parsePresentation(_ event: Dictionary<String, AnyObject>) -> EventType.Presentation? {
        guard
            let hasPhysical = event["has_physical"] as? Bool,
            let hasVirtual = event["has_virtual"] as? Bool,
            let isInhouse = event["is_inhouse"] as? Bool
        else {
            return nil
        }
        
        if !hasPhysical && !hasVirtual {
            return nil
        }
        
        return EventType.Presentation(mode: hasPhysical && hasVirtual ? .Hybrid : (hasVirtual ? .Virtual : .Physical),
                                      location: isInhouse ? .Indoors : .Virtual
        )
    }
    
    fileprivate func parseDate(_ time: String) -> Date {
        if let result = Date.parse(time, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            return result;
        }
        
        return Date.now()
    }
    
    fileprivate func parseEventDescription(_ eventDescription : String?) -> String? {
        return eventDescription?
            .replace(pattern: "<img", withTemplate: "<ximg")?
            .replace(pattern: "/img>", withTemplate: "/ximg>")?
            .replace(pattern: "<iframe", withTemplate: "<xiframe")?
            .replace(pattern: "iframe>", withTemplate: "xiframe>");
    }
}

