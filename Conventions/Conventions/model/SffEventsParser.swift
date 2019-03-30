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
            try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray,
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
            
//            guard let category = categories.firstObject as? String else {
//                print("Event missing categories. Skipping. ID=", eventId);
//                continue;
//            }
            // Current API returns ticket_limit = 0 even for events that dont require tickets.
            // We identify such events according to the ticket_limit property - if it's missing, the event is public.
            let availableTickets = event["ticket_limit"] as? String != nil ?event["available_tickets"] as? Int : nil
            
            var eventPrice = 0
            if let price = event["price"] as? String,
                let intPrice = Int(price) {
                eventPrice = intPrice
            }
            
            // Tags are returned as an object: {1: "tag1", 2: "tag2"} or a string: "tag1"
            var tags: Array<String> = []
            if let tag = event["tags"] as? String {
                tags.append(tag)
            }
            if let tagsObject = event["tags"] as? Dictionary<String, String> {
                for tagString in tagsObject.values {
                    tags.append(tagString.stringByDecodingHTMLEntities)
                }
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
                    description: eventType),
                hall: Convention.instance.findHallByName(hallName),
                description: parseEventDescription(description),
                category: "",//category.stringByDecodingHTMLEntities,
                price: eventPrice,
                tags: tags,
                url: URL(string: (event["url"] as? String)!)!)
            
            conventionEvent.availableTickets = availableTickets
            
            result.append(conventionEvent)
            
        }
        
        return result;
    }
    
    fileprivate func parseDate(_ time: String) -> Date {
        // Needed since current API wrongly reports the timezone as GMT instead of GMT+3
        let fixedTime = time.replacingOccurrences(of: "+00:00", with: "+03:00")
        if let result = Date.parse(fixedTime, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
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

