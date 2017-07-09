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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: NSStringFromClass(type(of: self)))
        tracker?.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any])
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Hide the feedback menu if not yet relevant
        if indexPath.row == 0 && !Convention.instance.canFillConventionFeedback() {
            return 0
        }
        
        return 44
    }
}
