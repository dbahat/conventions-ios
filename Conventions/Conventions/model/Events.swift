//
//  Events.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Events {
    private static let eventsApiUrl = "https://api.sf-f.org.il/program/list_events.php?slug=icon2016";
    private static let fileName = Convention.name + "Events.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "2_" + fileName;
    
    private var events: Array<ConventionEvent> = [];
    
    init(halls: Array<Hall>) {
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        if let cachedEvents = NSData(contentsOfFile: Events.cacheFile) {
            if let parsedCachedEvents = parse(cachedEvents, halls: halls) {
                events = parsedCachedEvents
                print("Cached events: ", events.count)
            }
        } else if let preInstalledEvents = NSData(contentsOfFile: resourcePath + "/" + Events.fileName) {
            if let parsedPreInstalledEvents = parse(preInstalledEvents, halls: halls) {
                events = parsedPreInstalledEvents
                print("Preinstalled events: ", events.count)
            }
        }
    }
    
    func getAll() -> Array<ConventionEvent> {
        return events;
    }
    
    func refresh(callback: ((success: Bool) -> Void)?) {
        download({result in
            guard let events = result else {
                dispatch_async(dispatch_get_main_queue()) {
                    callback?(success: false);
                }
                return;
            }
            
            //result?.writeToFile(Events.cacheFile, atomically: true);
            let parsedEvents = SffEventsParser().parse(data: events)
            if let serializedData = try? NSJSONSerialization.dataWithJSONObject(
                self.events.map({$0.toJson()}),
                options: NSJSONWritingOptions.PrettyPrinted) {
                serializedData.writeToFile(Events.cacheFile, atomically: true)
            }
            
            // Using main thread for syncronizing access to events
            dispatch_async(dispatch_get_main_queue()) {
                self.events = parsedEvents;
                print("Downloaded events: ", self.events.count);
                callback?(success: true);
            }
        });
    }
    
    private func parse(data: NSData, halls: Array<Hall>) -> Array<ConventionEvent>? {
        var result = Array<ConventionEvent>()
        
        guard let deserializedEvents =
            try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray,
            parsedEvents = deserializedEvents
            else {
                print("Failed to deserialize events");
                return result;
        }
        
        for event in parsedEvents {
            if let parsedEvent = ConventionEvent.parse(event as! Dictionary<String, AnyObject>, halls: halls) {
                result.append(parsedEvent)
            }
        }
        
        return result
    }
    
    private func download(completion: (data: NSData?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
        let url = NSURL(string: Events.eventsApiUrl)!;
        
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completion(data: data);
        }).resume();
    }
}
