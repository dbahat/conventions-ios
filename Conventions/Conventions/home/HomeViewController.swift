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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the content view both here and in viewDidAppear since we don't want the user
        // to see a flicker of the non-initialized screen while the app loads (observed on iphone 5c)
        homeContentContainer.addSubview(createHomeContentView())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
        
        homeContentContainer.subviews.forEach({ $0.removeFromSuperview() })
        homeContentContainer.addSubview(createHomeContentView())
    }
    
    private func createHomeContentView() -> UIView {
        let currentFavoriteEvent = getCurrentFavoriteEvent()
        
        if (Date.now().timeIntervalSince1970 < Convention.date.timeIntervalSince1970) {
            let contentView = BeforeConventionHomeContentView(frame: homeContentContainer.bounds)
            contentView.setDates(start: Convention.date, end: Convention.endDate)
            contentView.delegate = self
            return contentView
        }
        if (!Convention.instance.events.getAll().contains(where: {!$0.hasStarted()}) && currentFavoriteEvent == nil) {
            let contentView = AfterConventionHomeContentView(frame: homeContentContainer.bounds)
            contentView.delegate = self
            return contentView
        }
        
        let upcomingFavoriteEvent = getUpcomingFavoriteEvent()
        
        if (currentFavoriteEvent == nil && upcomingFavoriteEvent == nil) {
            let contentView = DuringConventionNoFavoritesHomeContentView(frame: homeContentContainer.bounds)
            contentView.delegate = self
            contentView.setEvents(getUpcomingEvents())
            return contentView
        }
        
        let contentView = DuringConventionWithFavoritesHomeContentView(frame: homeContentContainer.bounds)
        contentView.delegate = self
        contentView.currentFavoriteEvent = currentFavoriteEvent
        contentView.upcomingFavoriteEvent = upcomingFavoriteEvent
        return contentView
    }
    
    private func getUpcomingEvents() -> Array<ConventionEvent> {
        let upcomingEvents = Convention.instance.events.getAll()
            .filter({$0.startTime.timeIntervalSince1970 >= Date.now().timeIntervalSince1970})
            .sorted(by: {$0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970})
        
        let nextEventBatchStartTime = upcomingEvents.first?.startTime
        return upcomingEvents
            .filter({$0.startTime == nextEventBatchStartTime})
            .sorted(by: {$0.hall.order < $1.hall.order})
    }
    
    private func getCurrentFavoriteEvent() -> ConventionEvent? {
        return Convention.instance.events.getAll()
            .filter({$0.attending && $0.hasStarted() && !$0.hasEnded()})
            .first
    }
    
    private func getUpcomingFavoriteEvent() -> ConventionEvent? {
        return Convention.instance.events.getAll()
            .sorted(by: {$0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970})
            .filter({$0.attending && !$0.hasStarted()})
            .first
    }
    
    func navigateToUpdatesClicked() {
        // Since for icon2020 updates was placed in the main bar instead of the map screen
        tabBarController?.selectedIndex = 1
//        if let updatesVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: UpdatesViewController.self)) as? UpdatesViewController {
//            navigationController?.pushViewController(updatesVc, animated: true)
//        }
    }
    
    func navigateToFeedbackClicked() {
        if let feedbackVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ConventionFeedbackViewController.self)) as? ConventionFeedbackViewController {
            navigationController?.pushViewController(feedbackVc, animated: true)
        }
    }
    
    func navigateToEventsClicked() {
        tabBarController?.selectedIndex = 3
    }
    
    func navigateToFavoritesClicked() {
        tabBarController?.selectedIndex = 2
    }
    
    func navigateToEventClicked(event: ConventionEvent) {
        if let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? EventViewController {
            eventVc.event = event
            navigationController?.pushViewController(eventVc, animated: true)
        }
    }
}
