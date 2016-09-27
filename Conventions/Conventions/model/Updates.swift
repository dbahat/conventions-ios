//
//  SffUpdates.swift
//  Conventions
//
//  Created by David Bahat on 9/26/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Updates {
    private static let apiUrl = "https://api.sf-f.org.il/announcements/get.php?slug=icon2016";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + Convention.name + "Updates.json";
    private var updates: Array<Update> = [];
    
    init() {
        if let cachedUpdates = load() {
            updates = cachedUpdates;
        }
    }
    
    func getAll() -> Array<Update> {
        return updates;
    }
    
    func markAllAsRead() {
        updates.forEach({$0.isNew = false});
        save();
    }
    
    func refresh(callback: ((success: Bool) -> Void)?) {
        download({result in
            guard let updates = result else {
                dispatch_async(dispatch_get_main_queue()) {
                    callback?(success: false)
                }
                return;
            }
            
            let parsedUpdates = self.parse(updates)
            let sortedUpdates = parsedUpdates.sort({$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
            
            // Using main thread for syncronizing access to events
            dispatch_async(dispatch_get_main_queue()) {
                self.updates = sortedUpdates;
                print("Downloaded updates: ", self.updates.count)
                callback?(success: true)
                
                // Persist the updated events in a background thread, so as not to block the UI
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.save()
                }
            }
        });
    }
    
    private func download(completion: (data: NSData?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
        let url = NSURL(string: Updates.apiUrl)!;
        
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completion(data: data);
        }).resume();
    }
    
    private func parse(response: NSData) -> Array<Update> {
        
        var result = Array<Update>();
        
        guard let deserializedEvents =
            try? NSJSONSerialization.JSONObjectWithData(response, options: []) as? NSArray,
            updates = deserializedEvents
            else {
                print("Failed to deserialize updates");
                return result;
        }
        
        for update in updates {
            guard let id = update["id"] as? String else {
                print("Got update without ID. Skipping");
                continue;
            }
            guard let text = update["content"] as? String else {
                print("Got update without ID. Skipping");
                continue;
            }
            guard let time = update["update_time"] as? String else {
                print("Got update without ID. Skipping");
                continue;
            }
            
            result.append(Update(id: id, text: text, date: parseDate(time)))
        }
        
        return result
    }
    
    private func parseDate(time: String) -> NSDate {
        if let result = NSDate.parse(time, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            return result;
        }
        
        return NSDate()
    }
    
    private func save() {
        let serializedUpdates = self.updates.map({$0.toJson()});
        
        let json = try? NSJSONSerialization.dataWithJSONObject(serializedUpdates, options: NSJSONWritingOptions.PrettyPrinted);
        json?.writeToFile(Updates.cacheFile, atomically: true);
    }
    
    private func load() -> Array<Update>? {
        guard let storedUpdates = NSData(contentsOfFile: Updates.cacheFile) else {
            return nil;
        }
        guard let updatesJson = try? NSJSONSerialization.JSONObjectWithData(storedUpdates, options: NSJSONReadingOptions.AllowFragments) else {
            return nil;
        }
        guard let parsedUpdates = updatesJson as? [Dictionary<String, AnyObject>] else {
            return nil;
        }
        
        var result = Array<Update>();
        parsedUpdates.forEach({parsedUpdate in
            if let update = Update(json: parsedUpdate) {
                result.append(update);
            }
        });
        return result;
    }
}
