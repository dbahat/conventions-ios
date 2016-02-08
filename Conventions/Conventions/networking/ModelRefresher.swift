//
//  ModelDownloader.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class ModelRefresher {
    
    var session: NSURLSession!;
    var url: NSURL!;
    
    init() {
        url = NSURL(string: "http://2015.cami.org.il/wp-admin/admin-ajax.php?action=get_event_list");
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
    }
    
    func refresh(completion: (Bool) -> Void) {
        session.dataTaskWithURL(url, completionHandler: {
            (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse;
            if (httpResponse.statusCode == 200 && data != nil) {
                Convention.instance.events = ModelParser().parse(data!);
                completion(true);
            } else {
                completion(false);
            }
        }).resume();
    }
}