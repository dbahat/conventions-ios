//
//  TabBarViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/25/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad();
        
        selectedIndex = 4;
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.eventAttendanceWasSet), name: ConventionEvent.AttendingWasSetEventName, object: nil);
        
        delegate = self;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let eventsVc = viewController as? EventsViewController {
            eventsVc.shouldScrollToCurrentDateAndTime = true
        }
        if let myEventsVc = viewController as? MyEventsViewController {
            myEventsVc.shouldScrollToCurrentDateAndTime = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unhide the nav bar in case it was hidden (e.g. by the HomeViewController)
        navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    func eventAttendanceWasSet(_ notification: Notification) {
        // Whenever an event attance is set, show a badge in the favorites screen icon to give the user
        // a visual indication on what happened.
        //
        // Using tag to find MyEvents tab icon since it's possible the ViewController associated with it
        // was not yet intialized.
        self.tabBar.items?.filter({$0.tag == 100}).first?.badgeValue = "!";
    }
}
