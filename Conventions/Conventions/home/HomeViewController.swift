//
//  HomeViewController.swift
//  Conventions
//
//  Created by David Bahat on 16/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class HomeViewController : BaseViewController, ConventionHomeContentViewProtocol {
    
    @IBOutlet weak var homeContentContainer: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
        
        homeContentContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        if (Date.now().timeIntervalSince1970 < Convention.date.timeIntervalSince1970) {
            let homeContentView = BeforeConventionHomeContentView(frame: homeContentContainer.bounds)
            homeContentView.delegate = self
            homeContentView.setDates(start: Convention.date, end: Convention.endDate)
            homeContentContainer.addSubview(homeContentView)
        }
    }
    
    func navigateToUpdatesClicked() {
        if let updatesVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: UpdatesViewController.self)) as? UpdatesViewController {
            navigationController?.pushViewController(updatesVc, animated: true)
        }
    }
    
    func navigateToEventsClicked() {
        tabBarController?.selectedIndex = 3
    }
}
