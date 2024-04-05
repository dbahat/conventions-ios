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
        
        if shouldShowTabBar() {
            // Set the tab bar (which is also in the navigation controller) to have the title / button of the
            // current tab.
            tabBarController?.navigationItem.title = navigationItem.title
            navigationController?.navigationBar.backgroundColor = Colors.navigationBarBackgroundColor
        } else {
            tabBarController?.navigationItem.title = ""
            navigationController?.navigationBar.backgroundColor = Colors.clear
        }
        
        tabBarController?.navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItem
        tabBarController?.navigationItem.leftBarButtonItem = navigationItem.leftBarButtonItem
        
        // Hide the navigation bar on the root view controller (this is done by default only when the
        // root view controller doesn't have a name, but we want it named for the default back button).
        navigationController?.setNavigationBarHidden(navigationController?.viewControllers.first == self, animated: false)
        
        navigationController?.navigationBar.barTintColor = Colors.navigationBarTextColor
        navigationController?.navigationBar.tintColor = Colors.navigationBarTextColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.navigationBarTextColor]

        self.view.backgroundColor = Colors.backgroundColor
    }
    
    func shouldShowTabBar() -> Bool {
        return true
    }
}
