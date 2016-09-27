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
    func parse(data data:NSData) -> Array<ConventionEvent>! {
        return parse(data: data, halls: Convention.instance.halls);
    }
    
    func parse(data data: NSData, halls: Array<Hall>!) -> Array<ConventionEvent>! {
        var result = Array<ConventionEvent>();
        
        guard let deserializedEvents =
            try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray,
            events = deserializedEvents
        else {
            print("Failed to deserialize events");
            return result;
        }
        
        for event in events {
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
            guard let startTime = event["time"]??["start"] as? String else {
                print("Event missing startTime. Skipping. ID=", eventId);
                continue;
            }
            guard let endTime = event["time"]??["end"] as? String else {
                print("Event missing endTime. Skipping. ID=", eventId);
                continue;
            }
            guard
                let hallName = event["location"] as? String,
                let hall = findHallByName(halls, hallName: hallName)
            else {
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
                    tags.append(tagString)
                }
            }
            
            var speaker = ""
            if let speakers = event["speakers"] as? NSArray {
                speaker = speakers.count > 0 ? speakers.componentsJoinedByString(",") : ""
            }
            
            let conventionEvent = ConventionEvent(
                id: eventId,
                serverId: Int(eventId) ?? 0,
                color: Colors.eventTimeDefaultBackgroundColor,
                textColor: nil,
                title: String(htmlEncodedString: title),
                lecturer: String(htmlEncodedString: speaker),
                startTime: parseDate(startTime),
                endTime: parseDate(endTime),
                type: EventType(
                    backgroundColor: nil,
                    description: eventType),
                hall: hall,
                description: parseEventDescription(description),
                category: category,
                price: eventPrice,
                tags: tags)
            
            result.append(conventionEvent)
            
        }
        
        return result;
    }
    
    private func findHallByName(halls: Array<Hall>, hallName: String) -> Hall? {
        if let hall = halls.filter({hall in hall.name == hallName}).first {
            return hall
        }
        
        return nil
    }
    
    private func parseDate(time: String) -> NSDate {
        if let result = NSDate.parse(time, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            return result;
        }
        
        return NSDate()
    }
    
    private func parseEventDescription(eventDescription : String?) -> String? {
        return eventDescription?
            .replace(pattern: "<img", withTemplate: "<ximg")?
            .replace(pattern: "/img>", withTemplate: "/ximg>")?
            .replace(pattern: "<iframe", withTemplate: "<xiframe")?
            .replace(pattern: "iframe>", withTemplate: "xiframe>");
    }
}

extension String {
    init(htmlEncodedString: String) {
        do {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
}

