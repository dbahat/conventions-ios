//
//  BaseViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/4/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import Firebase

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the tab bar (which is also in the navigation controller) to have the title / button of the 
        // current tab.
        tabBarController?.navigationItem.title = navigationItem.title
        tabBarController?.navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItem
        tabBarController?.navigationItem.leftBarButtonItem = navigationItem.leftBarButtonItem
        
        // Hide the navigation bar on the root view controller (this is done by default only when the
        // root view controller doesn't have a name, but we want it named for the default back button).
        navigationController?.setNavigationBarHidden(navigationController?.viewControllers.first == self, animated: false)
        
        navigationController?.navigationBar.barTintColor = Colors.textColor
        navigationController?.navigationBar.tintColor = Colors.textColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.textColor]

        self.view.backgroundColor = Colors.backgroundColor
    }
}
