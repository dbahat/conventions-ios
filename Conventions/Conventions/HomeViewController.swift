//
//  HomeViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/25/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModelRefresher().refresh({(result) in
            print(result);
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarViewController") as? TabBarViewController {
            vc.selectedIndex = selectedIndex;
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
