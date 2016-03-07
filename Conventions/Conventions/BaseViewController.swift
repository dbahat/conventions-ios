//
//  BaseViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // Send an event that the screen was visited
        let tracker = GAI.sharedInstance().defaultTracker;
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType));
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]);
        
        // Set the tab bar (which is also in the navigation controller) to have the title of the current tab.
        tabBarController?.navigationItem.title = navigationItem.title;
        
        // Hide the navigation bar on the root view controller (this is done by default only when the
        // root view controller doesn't have a name, but we want it named for the default back button).
        navigationController?.setNavigationBarHidden(navigationController?.viewControllers.first == self, animated: false);
    }
}