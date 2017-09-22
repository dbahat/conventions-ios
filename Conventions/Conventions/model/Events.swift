//
//  Events.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Events {
    fileprivate static let eventsApiUrl = "https://api.sf-f.org.il/program/list_events.php?slug=icon2017";
    fileprivate static let fileName = Convention.name + "Events.json";
    fileprivate static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "1_" + fileName;
    
    fileprivate var events: Array<ConventionEvent> = [];
    
    init(halls: Array<Hall>) {
        guard let resourcePath = Bundle.main.resourcePath else {
            return;
        };
        
        if let cachedEvents = try? Data(contentsOf: URL(fileURLWithPath: Events.cacheFile)) {
            if let parsedCachedEvents = parse(cachedEvents, halls: halls) {
                events = parsedCachedEvents
                print("Cached events: ", events.count)
            }
        } else if let preInstalledEvents = try? Data(contentsOf: URL(fileURLWithPath: resourcePath + "/" + Events.fileName)) {
            if let parsedPreInstalledEvents = parse(preInstalledEvents, halls: halls) {
                events = parsedPreInstalledEvents
                print("Preinstalled events: ", events.count)
            }
        }
    }
    
    func getAll() -> Array<ConventionEvent> {
        return events;
    }
    
    func refresh(_ callback: ((_ success: Bool) -> Void)?) {
        // Don't refresh events after the convention has ended
        if (Convention.endDate.timeIntervalSince1970 < Date.now().clearTimeComponent().timeIntervalSince1970) {
            callback?(true)
        }
        
        download({result in
            guard let events = result else {
                DispatchQueue.main.async {
                    callback?(false);
                }
                return;
            }
            
            let parsedEvents = SffEventsParser().parse(data: events)
            if let serializedData = try? JSONSerialization.data(
                withJSONObject: self.events.map({$0.toJson()}),
                options: JSONSerialization.WritingOptions.prettyPrinted) {
                try? serializedData.write(to: URL(fileURLWithPath: Events.cacheFile), options: [.atomic])
            }
            
            // Using main thread for syncronizing access to events
            DispatchQueue.main.async {
                self.events = parsedEvents!;
                print("Downloaded events: ", self.events.count);
                callback?(true);
            }
        });
    }
    
    fileprivate func parse(_ data: Data, halls: Array<Hall>) -> Array<ConventionEvent>? {
        var result = Array<ConventionEvent>()
        
        guard let deserializedEvents =
            try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray,
            let parsedEvents = deserializedEvents
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
    
    fileprivate func download(_ completion: @escaping (_ data: Data?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default);
        let url = URL(string: Events.eventsApiUrl)!;
        
        session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            completion(data);
        }).resume();
    }
}
