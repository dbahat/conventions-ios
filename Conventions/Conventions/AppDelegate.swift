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

    var window: UIWindow?;

    private static let eventsCacheFileName = NSHomeDirectory() + "/Library/Caches/CamiEvents.json";

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.redColor();
        
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.ForceLeftToRight;
        }
        
        if let cachedEvents = NSData(contentsOfFile: AppDelegate.eventsCacheFileName) {
            Convention.instance.events = EventsParser().parse(cachedEvents);
            print("Events from cache: ", Convention.instance.events?.count);
        }
        
        EventsDownloader().download({(result) in
            guard let events = result else {
                return;
            }
            
            result?.writeToFile(AppDelegate.eventsCacheFileName, atomically: true);
            
            // Using main thread for syncronizing access to Convention.instance
            dispatch_async(dispatch_get_main_queue()) {
                Convention.instance.events = EventsParser().parse(events);
                print("Downloaded events: ", Convention.instance.events?.count);
            }
        });
        
        return true
    }
}

