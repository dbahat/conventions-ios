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
    }
}