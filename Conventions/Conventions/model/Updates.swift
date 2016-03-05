//
//  Updates.swift
//  Conventions
//
//  Created by David Bahat on 3/5/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Updates {
    private var updates: Array<Update> = [];
    
    func getAll() -> Array<Update> {
        return updates;
    }
    
    func markAllAsRead() {
        updates.forEach({$0.isNew = false});
    }
    
    func refresh(callback: (() -> Void)?) {
        if FBSDKAccessToken.currentAccessToken() == nil {
            callback?();
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
            let updates = self.parseFacebookResult(result)
                .sort({ $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 });

            // Using main thread for syncronizing access to updates
            dispatch_async(dispatch_get_main_queue()) {
                self.updates.appendContentsOf(updates);
                print("Downloaded updates ", self.updates.count);
                callback?();
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
}