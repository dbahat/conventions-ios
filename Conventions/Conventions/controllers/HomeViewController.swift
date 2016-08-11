//
//  HomeViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/25/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet private weak var arrivalMethodsImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Change the device back to Portrait for this screen (as all others support landscape)
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        if Convention.date.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
            arrivalMethodsImage.image = UIImage(named: "OpeningFeedback")
        }
    }
    
    @IBAction private func eventsWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(4)
    }
    
    @IBAction private func mapWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(2)
    }

    @IBAction private func updatedWasTapped(sender: UITapGestureRecognizer) {
        navigateToTabController(1)
    }
    
    @IBAction private func arrivalMethodsWasTapped(sender: UITapGestureRecognizer) {
        // After the convention is over, the arrival methods button becomes the convention feedback button
        if Convention.date.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
            performSegueWithIdentifier("HomeToFeedbackSegue", sender: nil)
        } else {
            navigateToTabController(0)
        }
    }
    
    @IBAction private func FeedbackWasTapped(sender: UITapGestureRecognizer) {
        
    }
    
    private func navigateToTabController(selectedIndex: Int) {
        performSegueWithIdentifier("HomeToTabBarSegue", sender: selectedIndex);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabBarViewController = segue.destinationViewController as? TabBarViewController;
        tabBarViewController?.selectedIndex = sender as! Int;
    }
}
