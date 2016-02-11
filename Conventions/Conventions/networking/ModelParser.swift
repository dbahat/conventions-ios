//
//  ModelParser.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

class ModelParser {
    func parse(data: NSData!) -> Array<ConventionEvent> {
        var result = Array<ConventionEvent>();
        
        do {
            if let events = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                for event in events {
                    let eventId = event["ID"] as! Int?;
                    let eventType = event["categories-text"]!!["name"] as! String?;
                    
                    print(eventId, eventType);
                    let internalEvents = event["timetable-info"] as! Array<NSDictionary>;
                    for internalEvent in internalEvents {
                        if (internalEvent["tooltip"] as! String? == "hidden") {
                            continue;
                        }
                        
                        let startTime = formatDate(internalEvent["start"] as! String!);
                        let endTime = formatDate(internalEvent["end"] as! String!);
                        let room = internalEvent["room"] as! String!;
                        let description = parseEventDescription(event["content"] as! String?);
                        let color = UIColor(hexString: event["timetable-bg"] as! String!);
                        
                        let conventionEvent = ConventionEvent(
                            id: String(format: "%d_%d", arguments: [eventId!, 1]),
                            serverId: event["ID"] as! Int?,
                            color: color,
                            title: event["title"] as! String?,
                            lecturer: internalEvent["before_hour_text"] as! String?,
                            startTime: startTime,
                            endTime: endTime,
                            type: nil,
                            hall: Hall(name: room),
                            description: description);
                        
                        result.append(conventionEvent);
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return result;
    }
    
    func formatDate(date: String!) -> NSDate? {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy:MM:dd";
        dateFormatter.locale = NSLocale.systemLocale();
        let conventionDate = dateFormatter.stringFromDate(Convention.instance.date);
        
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss";
        return dateFormatter.dateFromString(conventionDate + " " + date);
    }
    
    func parseEventDescription(eventDescription : String?) -> String? {
        return eventDescription?
            .removeAll(pattern: "class=\"[^\"]*\"")
            .removeAll(pattern: "style=\"[^\"]*\"")
            .removeAll(pattern: "width=\"[^\"]*\"")
            .removeAll(pattern: "height=\"[^\"]*\"")
            .replace(pattern: "<div", withTemplate: "<xdiv")
            .replace(pattern: "/div>", withTemplate: "/xdiv")
            .replace(pattern: "\t", withTemplate: "    ")
            .replace(pattern: "<img", withTemplate: "<ximg")
            .replace(pattern: "/img>", withTemplate: "/ximg>");
    }
}

extension String {
    func removeAll(pattern pattern: String) -> String {
        return replace(pattern: pattern, withTemplate: "");
    }
    
    func replace(pattern pattern: String, withTemplate template: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive);
        return regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: template);
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}