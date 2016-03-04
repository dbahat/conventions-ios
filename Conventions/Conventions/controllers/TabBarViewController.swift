//
//  TabBarViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/25/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventAttendanceWasSet:", name: ConventionEvent.AttendingWasSetEventName, object: nil);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // Send an event that the screen was visited. Not taken from BaseViewController since we derive from UITabBarController.
        // Not adding a new base since we probebly won't have more UITabBarController.
        let tracker = GAI.sharedInstance().defaultTracker;
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType));
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]);
    }
    
    func eventAttendanceWasSet(notification: NSNotification) {
        // Whenever an event attance is set, show a badge in the favorites screen icon to give the user
        // a visual indication on what happened.
        //
        // Using tag to find MyEvents tab icon since it's possible the ViewController associated with it
        // was not yet intialized.
        self.tabBar.items?.filter({$0.tag == 100}).first?.badgeValue = "+";
    }
}
