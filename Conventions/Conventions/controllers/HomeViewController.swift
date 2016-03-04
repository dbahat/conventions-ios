//
//  HomeViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/25/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func eventsWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(0);
    }
    
    @IBAction func mapWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(1);
    }
    
    
    @IBAction func arrivalMethodsWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(2);
    }

    @IBAction func updatedWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(3);
    }
    
    private func navigateToTabController(selectedIndex: Int) {
        performSegueWithIdentifier("HomeToTabBarSegue", sender: selectedIndex);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabBarViewController = segue.destinationViewController as? TabBarViewController;
        tabBarViewController?.selectedIndex = sender as! Int;
    }
}
