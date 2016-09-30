//
//  MoreInfoViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

// Using UITableViewController since we want this tableView to have static cells
class MoreInfoViewController : UITableViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType))
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Hide the feedback menu if not yet relevant
        if indexPath.row == 0 && !Convention.instance.canFillConventionFeedback() {
            return 0
        }
        
        return 44
    }
}
