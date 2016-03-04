//
//  MyEventsNavigationController.swift
//  Conventions
//
//  Created by David Bahat on 2/26/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MyEventsNavigationController: UINavigationController {
    @IBOutlet weak var tabBarIcon: UITabBarItem!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // Adding to my events will trigger a badge icon to hint the user to click my events.
        // Once clicked we can clear the badge.
        tabBarIcon.badgeValue = nil;
    }
}
