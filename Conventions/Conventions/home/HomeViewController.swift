//
//  HomeViewController.swift
//  Conventions
//
//  Created by David Bahat on 16/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class HomeViewController : BaseViewController, ConventionHomeContentViewProtocol {
    
    @IBOutlet private weak var homeContentContainer: UIView!
    @IBOutlet private weak var homeFooterImage: UIImageView!
    @IBOutlet private weak var homeTopImage: UIImageView!
    @IBOutlet private weak var homeContentContainerTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var homeContentContainerBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the content view both here and in viewDidAppear since we don't want the user
        // to see a flicker of the non-initialized screen while the app loads (observed on iphone 5c)
        homeContentContainer.addSubview(createHomeContentView())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeContentContainer.subviews.forEach({ $0.removeFromSuperview() })
        homeContentContainer.addSubview(createHomeContentView())
    }
    
    override func shouldShowTabBar() -> Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reloading the page both in ViewWillAppear and DidAppear since some parts of the layout (e.g. Current/Next event) are better
        // replaced during WillAppear (so there won't be a flicker), while some (like the Go to favorites button) requires screen layout to complete
        // for the contraints to peoperly take effect.
        homeContentContainer.subviews.forEach({ $0.removeFromSuperview() })
        homeContentContainer.addSubview(createHomeContentView())
    }
    
    private func createHomeContentView() -> UIView {
        let currentFavoriteEvent = getCurrentFavoriteEvent()
        
        if (Date.now().timeIntervalSince1970 < Convention.date.timeIntervalSince1970) {
            let contentView = BeforeConventionHomeContentView(frame: homeContentContainer.bounds)
            homeFooterImage.image = nil
            homeTopImage.image = nil
            homeContentContainerTopLayoutConstraint.isActive = true
            homeContentContainerBottomLayoutConstraint.isActive = true
            contentView.setDates(start: Convention.date, end: Convention.endDate)
            contentView.delegate = self
            return contentView
        }
        if (!Convention.instance.events.getAll().contains(where: {!$0.hasStarted()}) && currentFavoriteEvent == nil) {
            let contentView = AfterConventionHomeContentView(frame: homeContentContainer.bounds)
            contentView.delegate = self
            homeFooterImage.image = nil
            homeTopImage.image = nil
            homeContentContainerTopLayoutConstraint.isActive = true
            homeContentContainerBottomLayoutConstraint.isActive = true
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
            .sorted(by: {
                if $0.startTime.timeIntervalSince1970 == $1.startTime.timeIntervalSince1970 {
                    return !$0.isOngoing // depriorities ongoing events
                }
                
                return $0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970
            }
            )
            .first
    }
    
    private func getUpcomingFavoriteEvent() -> ConventionEvent? {
        return Convention.instance.events.getAll()
            .filter({$0.attending && !$0.hasStarted()})
            .sorted(by: {
                if $0.startTime.timeIntervalSince1970 == $1.startTime.timeIntervalSince1970 {
                    return !$0.isOngoing // depriorities ongoing events
                }
                
                return $0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970
            })
            .first
    }
    
    func navigateToUpdatesClicked() {
        tabBarController?.selectedIndex = 1
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
