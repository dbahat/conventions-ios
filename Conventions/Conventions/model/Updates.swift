//
//  SffUpdates.swift
//  Conventions
//
//  Created by David Bahat on 9/26/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Updates {
    fileprivate static let apiUrl = "https://api.sf-f.org.il/announcements/get.php?slug=icon2017";
    fileprivate static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + Convention.name + "Updates.json";
    fileprivate var updates: Array<Update> = [];
    
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
    
    func refresh(_ callback: ((_ success: Bool) -> Void)?) {
        download({result in
            guard let updates = result else {
                DispatchQueue.main.async {
                    callback?(false)
                }
                return;
            }
            
            let parsedUpdates = self.parse(updates)
            let sortedUpdates = parsedUpdates.sorted(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
            
            // Using main thread for syncronizing access to events
            DispatchQueue.main.async {
                self.updates = sortedUpdates;
                print("Downloaded updates: ", self.updates.count)
                callback?(true)
                
                // Persist the updated events in a background thread, so as not to block the UI
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                    self.save()
                }
            }
        });
    }
    
    fileprivate func download(_ completion: @escaping (_ data: Data?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default);
        let url = URL(string: Updates.apiUrl)!;
        
        session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            completion(data);
        }).resume();
    }
    
    fileprivate func parse(_ response: Data) -> Array<Update> {
        
        var result = Array<Update>();
        
        guard let deserializedEvents =
            try? JSONSerialization.jsonObject(with: response, options: []) as? NSArray,
            let updates = deserializedEvents
            else {
                print("Failed to deserialize updates");
                return result;
        }
        
        for rawUpdate in updates {
            guard let update = rawUpdate as? Dictionary<String, AnyObject> else {
                print("Got invalid update. Skipping");
                continue;
            }
            
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
    
    fileprivate func parseDate(_ time: String) -> Date {
        if let result = Date.parse(time, dateFormat: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            return result;
        }
        
        return Date.now()
    }
    
    fileprivate func save() {
        let serializedUpdates = self.updates.map({$0.toJson()});
        
        let json = try? JSONSerialization.data(withJSONObject: serializedUpdates, options: JSONSerialization.WritingOptions.prettyPrinted);
        try? json?.write(to: URL(fileURLWithPath: Updates.cacheFile), options: [.atomic]);
    }
    
    fileprivate func load() -> Array<Update>? {
        guard let storedUpdates = try? Data(contentsOf: URL(fileURLWithPath: Updates.cacheFile)) else {
            return nil;
        }
        guard let updatesJson = try? JSONSerialization.jsonObject(with: storedUpdates, options: JSONSerialization.ReadingOptions.allowFragments) else {
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
