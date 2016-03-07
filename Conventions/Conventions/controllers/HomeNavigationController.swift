//
//  HomeNavigationController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class HomeNavigationController: UINavigationController {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return viewControllers.count == 1
            ? UIInterfaceOrientationMask.Portrait // The root ViewController should be Portrait only
            : UIInterfaceOrientationMask.All;
    }
}
