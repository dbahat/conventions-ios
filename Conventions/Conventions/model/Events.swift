//
//  Events.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Events {
    private static let eventsApiUrl = URL(string: "https://api.sf-f.org.il/program/list_events.php?slug=olamot2021")!;
    private static let availableTicketsCacheLastRefreshTimeApi = URL(string: "https://api.sf-f.org.il/program/cache_get_last_updated.php?slug=olamot2021&which=available_tickets")!
    
    private static let fileName = Convention.name + "Events.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "1_" + fileName;
    
    private var events: Array<ConventionEvent> = [];
    
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
        
        let request = URLRequest(url: Events.eventsApiUrl, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) -> Void in
            
            guard let events = data else {
                DispatchQueue.main.async {
                    callback?(false);
                }
                return;
            }
            
            let request = URLRequest(url: Events.availableTicketsCacheLastRefreshTimeApi, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
            URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) -> Void in
                
                guard let availableTicketsCallResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        callback?(false);
                    }
                    return
                }
                
                if (availableTicketsCallResponse.statusCode != 200) {
                    DispatchQueue.main.async {
                        callback?(false);
                    }
                    return
                }
                
                guard
                let availableTicketsLastModifiedString = availableTicketsCallResponse.allHeaderFields["Last-Modified"] as? String,
                let availableTicketsLastModifiedDate = Date.parse(availableTicketsLastModifiedString, dateFormat: "EEE, dd MMM yyyy HH:mm:ss zzz")
                else {
                    print("failed to fetch tickets last modified value")
                    
                    DispatchQueue.main.async {
                        callback?(false);
                    }
                    return
                }
                
                guard let parsedEvents = SffEventsParser().parse(data: events) else {
                    DispatchQueue.main.async {
                        callback?(false);
                    }
                    return
                }
                parsedEvents.forEach({$0.availableTicketsLastModified = availableTicketsLastModifiedDate})
                
                if let serializedData = try? JSONSerialization.data(
                    withJSONObject: parsedEvents.map({$0.toJson()}),
                    options: JSONSerialization.WritingOptions.prettyPrinted) {
                    try? serializedData.write(to: URL(fileURLWithPath: Events.cacheFile), options: [.atomic])
                }
                
                // Using main thread for syncronizing access to events
                DispatchQueue.main.async {
                    self.events = parsedEvents;
                    print("Downloaded events: ", self.events.count);
                    callback?(true);
                }
            }).resume()
        }).resume()
    }
    
    private func parse(_ data: Data, halls: Array<Hall>) -> Array<ConventionEvent>? {
        var result = Array<ConventionEvent>()
        
        guard let parsedEvents = deserialize(data) as? NSArray
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
    
    private func deserialize(_ data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
}
