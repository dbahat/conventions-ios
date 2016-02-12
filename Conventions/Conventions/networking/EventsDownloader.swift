//
//  ModelDownloader.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class EventsDownloader {

    private let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
    private let url = NSURL(string: "http://2015.cami.org.il/wp-admin/admin-ajax.php?action=get_event_list")!;
    
    func download(completion: (data: NSData?) -> Void) {
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completion(data: data);
        }).resume();
    }
}