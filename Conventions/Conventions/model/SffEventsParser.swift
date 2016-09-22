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
    func parse(data data:NSData!) -> Array<ConventionEvent>! {
        return parse(data: data, halls: Convention.instance.halls);
    }
    
    func parse(data data: NSData!, halls: Array<Hall>!) -> Array<ConventionEvent>! {
        var result = Array<ConventionEvent>();
        
        guard let deserializedEvents =
            try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray,
            events = deserializedEvents
        else {
            print("Failed to deserialize cached events");
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
            guard let hallName = event["location"] as? String else {
                print("Event missing room. Skipping. ID=", eventId);
                continue;
            }
            
            var speaker = ""
            if let speakers = event["speakers"] as? NSArray {
                speaker = speakers.count > 0 ? speakers.componentsJoinedByString(",") : ""
            }
            
            let conventionEvent = ConventionEvent(
                id: eventId,
                serverId: Int(eventId) ?? 0,
                color: nil,
                textColor: nil,
                title: String(htmlEncodedString: title),
                lecturer: String(htmlEncodedString: speaker),
                startTime: parseDate(startTime),
                endTime: parseDate(endTime),
                type: EventType(
                    backgroundColor: nil,
                    description: eventType),
                hall: findHallByName(halls, hallName: hallName),
                description: parseEventDescription(description));
            
            result.append(conventionEvent);
            
        }
        
        return result;
    }
    
    private func findHallByName(halls: Array<Hall>, hallName: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == hallName}).first {
            return hall;
        }
        
        return Hall(name: "", order: 100);
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

