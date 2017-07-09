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
            
            guard let categories = event["categories"] as? NSArray else {
                print("Event missing categories. Skipping. ID=", eventId);
                continue;
            }
            guard let category = categories.firstObject as? String else {
                print("Event missing categories. Skipping. ID=", eventId);
                continue;
            }
            
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
                    tags.append(tagString.decodeHtmlSymbols() ?? tagString)
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
                title: title.decodeHtmlSymbols() ?? title,
                lecturer: speaker.decodeHtmlSymbols() ?? speaker,
                startTime: parseDate(startTime),
                endTime: parseDate(endTime),
                type: EventType(
                    backgroundColor: nil,
                    description: eventType),
                hall: Convention.instance.findHallByName(hallName),
                description: parseEventDescription(description),
                category: category.decodeHtmlSymbols() ?? category,
                price: eventPrice,
                tags: tags,
                url: URL(string: (event["url"] as? String)!)!)
            
            result.append(conventionEvent)
            
        }
        
        return result;
    }
    
    fileprivate func parseDate(_ time: String) -> Date {
        if let result = Date.parse(time, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            return result;
        }
        
        return Date()
    }
    
    fileprivate func parseEventDescription(_ eventDescription : String?) -> String? {
        return eventDescription?
            .replace(pattern: "<img", withTemplate: "<ximg")?
            .replace(pattern: "/img>", withTemplate: "/ximg>")?
            .replace(pattern: "<iframe", withTemplate: "<xiframe")?
            .replace(pattern: "iframe>", withTemplate: "xiframe>");
    }
}

extension String {
    func decodeHtmlSymbols() -> String? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}

