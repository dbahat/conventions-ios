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
        } else {
            let upcomingEvents = Convention.instance.events.getAll()
                .filter({$0.startTime.timeIntervalSince1970 > Date.now().timeIntervalSince1970})
                .sorted(by: {$0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970})
            
            let nextEventBatchStartTime = upcomingEvents.first?.startTime
            let nextBatchUpcomingEvents = upcomingEvents
                .filter({$0.startTime == nextEventBatchStartTime})
                .sorted(by: {$0.hall.order < $1.hall.order})
            
            let homeContentView = DuringConventionNoFavoritesHomeContentView(frame: homeContentContainer.bounds)
            homeContentView.delegate = self
            homeContentView.setEvents(nextBatchUpcomingEvents)
            homeContentContainer.addSubview(homeContentView)
            
            //let homeContentView = AfterConventionHomeContentView(frame: homeContentContainer.bounds)
            //homeContentContainer.addSubview(homeContentView)
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
    
    func navigateToEventClicked(event: ConventionEvent) {
        if let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? EventViewController {
            eventVc.event = event
            navigationController?.pushViewController(eventVc, animated: true)
        }
    }
}
