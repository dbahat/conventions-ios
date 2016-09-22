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
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + fileName;
    
    private var events: Array<ConventionEvent> = [];
    
    init(halls: Array<Hall>) {
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        if let cachedEvents = NSData(contentsOfFile: Events.cacheFile) {
            events = SffEventsParser().parse(data: cachedEvents, halls: halls);
            print("Events from cache: ", events.count);
        } else if let preInstalledEvents = NSData(contentsOfFile: resourcePath + "/" + Events.fileName) {
            events = SffEventsParser().parse(data: preInstalledEvents, halls: halls);
            print("Preinstalled events: ", events.count);
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
            
            result?.writeToFile(Events.cacheFile, atomically: true);
            let parsedEvents = SffEventsParser().parse(data: events);
            
            // Using main thread for syncronizing access to events
            dispatch_async(dispatch_get_main_queue()) {
                self.events = parsedEvents;
                print("Downloaded events: ", self.events.count);
                callback?(success: true);
            }
        });
    }
    
    private func download(completion: (data: NSData?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
        let url = NSURL(string: Events.eventsApiUrl)!;
        
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completion(data: data);
        }).resume();
    }
}
