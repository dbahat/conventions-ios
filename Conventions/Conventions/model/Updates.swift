//
//  Updates.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Updates {
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
        if FBSDKAccessToken.currentAccessToken() == nil {
            dispatch_async(dispatch_get_main_queue()) {
                callback?(success: true /* So we won't show error if the user didn't sign in to facebook */);
            }
            return;
        }
        
        var request : FBSDKGraphRequest;
        if let latestUpdateTime = updates
            .maxElement({$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970}) {
                request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: ["since": (latestUpdateTime.date.timeIntervalSince1970)]);
        } else {
            request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: nil);
        }
        
        request.startWithCompletionHandler({ connection, result, error in
            
            if (error != nil || result == nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    callback?(success: false);
                }
                return;
            }
            
            let updates = self.parseFacebookResult(result)
                .sort({ $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 });

            // Using main thread for syncronizing access to updates
            dispatch_async(dispatch_get_main_queue()) {
                self.updates.appendContentsOf(updates);
                print("Downloaded updates ", self.updates.count);
                callback?(success: true);
                
                // Persist the updated events in a background thread, so as not to block the UI
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.save();
                }
            }
        });
    }
    
    private func parseFacebookResult(result: AnyObject!) -> Array<Update> {
        var updates = Array<Update>();
        guard let resultEvents = result["data"] as? [AnyObject] else {return updates;}
        for event in resultEvents {
            guard let id = event["id"] as? String else {continue;};
            guard let message = event["message"] as? String else {continue;}
            guard let createdTime = event["created_time"] as? String else {continue;}
            guard let parsedDate = NSDate.parse(createdTime, dateFormat: "yyyy-MM-dd'T'HH:mm:ssz") else {continue;}
            
            updates.append(Update(id: id, text: message, date: parsedDate));
        }
        
        return updates;
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