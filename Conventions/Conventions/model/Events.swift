//
//  Events.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Events {
    private static let eventsApiUrl = "http://2016.harucon.org.il/wp-admin/admin-ajax.php?action=get_event_list";
    private static let cacheFileName = "CamiEvents.json";
    private static let cacheFileNameAndPath = NSHomeDirectory() + "/Library/Caches/" + cacheFileName;
    
    private var events: Array<ConventionEvent> = [];
    
    init(halls: Array<Hall>) {
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        if let cachedEvents = NSData(contentsOfFile: Events.cacheFileNameAndPath) {
            events = EventsParser().parse(data: cachedEvents, halls: halls);
            print("Events from cache: ", events.count);
        } else if let preInstalledEvents = NSData(contentsOfFile: resourcePath + "/" + Events.cacheFileName) {
            events = EventsParser().parse(data: preInstalledEvents, halls: halls);
            print("Preinstalled events: ", events.count);
        }
    }
    
    func getAll() -> Array<ConventionEvent> {
        return events;
    }
    
    func refresh(callback: (() -> Void)?) {
        download({result in
            guard let events = result else {
                return;
            }
            
            result?.writeToFile(Events.cacheFileName, atomically: true);
            
            // Using main thread for syncronizing access to events
            dispatch_async(dispatch_get_main_queue()) {
                self.events = EventsParser().parse(data: events);
                print("Downloaded events: ", self.events.count);
                callback?();
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