//
//  AppDelegate.swift
//  Conventions
//
//  Created by David Bahat on 1/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let eventsCacheFileName = NSHomeDirectory() + "/Library/Caches/CamiEvents.json";

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.redColor();
        
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.ForceLeftToRight;
        }
        
        if let cachedEvents = NSData(contentsOfFile: eventsCacheFileName) {
            Convention.instance.events = EventsParser().parse(cachedEvents);
            print("Events from cache: ", Convention.instance.events?.count);
        }
        
        EventsDownloader().download({(result) in
            if (result != nil) {
                Convention.instance.events = EventsParser().parse(result);
                print("Downloaded events: ", Convention.instance.events?.count);
                result?.writeToFile(self.eventsCacheFileName, atomically: true);
            }
        });
        
        return true
    }
}

