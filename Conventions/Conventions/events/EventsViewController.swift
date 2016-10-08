//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate, SearchCategoriesProtocol, UISearchResultsUpdating, UISearchControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!

    private var eventsPerTimeSection: Dictionary<NSDate, Array<ConventionEvent>> = [:]
    private var eventTimeSections: Array<NSDate> = []
    
    var shouldScrollToCurrentDateAndTime = true

    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    private let tableViewController = UITableViewController()
    
    private var enabledCategories: Array<AggregatedSearchCategory> = [.Lectures, .Games, .Shows, .Others]
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet private weak var dateFilterControl: DateFilterControl!
    
    @IBOutlet private weak var searchCategoriesLayout: SearchCategoriesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let eventHeaderView = UINib(nibName: String(EventListHeaderView), bundle: nil)
        self.tableView.registerNib(eventHeaderView, forHeaderFooterViewReuseIdentifier: String(EventListHeaderView))
        
        addRefreshController()
        addSearchController()
        
        // Make initial model calculation when the view loads
        calculateEventsAndTimeSections()
        
        dateFilterControl.setDates(fromDate: Convention.date, toDate: Convention.endDate)
        searchCategoriesLayout.delegate = self
        
        // TODO - only perform this if an hour has passed since last refresh
        Convention.instance.events.refresh({success in
            self.tableView.reloadData()
        })
        
        // Initial loading of the table. Done here so we can auto-scroll to the first position, leaving the search bar control hidden
        calculateEventsAndTimeSections()
        tableView.reloadData()
        if eventTimeSections.count > 0 {
            // reset the scroll state when changing days for better user experiance
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // redraw the table when navigating in/out of the view, in case the model changed
        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        dispatch_async(dispatch_get_main_queue()) {
            // Disabling search during orientation/size changes since the search control seem to have issues when orientation changes 
            // (suddenly appearing in the wrong position).
            self.searchController.active = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollToCurrentRunningEventsIfNeeded()
    }
    
    private func scrollToCurrentRunningEventsIfNeeded() {
        if !Convention.instance.isRunning() || !shouldScrollToCurrentDateAndTime {
            return
        }
        
        dateFilterControl.selectDate(NSDate())
        calculateEventsAndTimeSections()
        tableView.reloadData()
        
        // If the convention is currently taking place, auto-scroll to the correct time section.
        // Dispatching to the next layout pass so the user will see the scroll animation
        tableView.layoutIfNeeded()
        dispatch_async(dispatch_get_main_queue()) {
            if let sectionIndex = self.getSectionIndex(forDate: NSDate()) {
                self.tableView.scrollToRowAtIndexPath(
                    NSIndexPath(forRow: 0, inSection: sectionIndex),
                    atScrollPosition: .Top,
                    animated: true)
                
                // only scroll once (or when set to scroll from externally)
                self.shouldScrollToCurrentDateAndTime = false
            }
        }
    }
    
    @IBAction func dateFilterTapped(sender: UISegmentedControl) {
        calculateEventsAndTimeSections()
        tableView.reloadData()
        
        if eventTimeSections.count > 0 {
            // reset the scroll state when changing days for better user experiance
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
    }
    
    func filterSearchCategoriesChanged(enabledCategories: Array<AggregatedSearchCategory>) {
        self.enabledCategories = enabledCategories

        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventTimeSections.count;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timeSection = eventTimeSections[section];
        return eventsPerTimeSection[timeSection]!.count;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(EventListHeaderView)) as! EventListHeaderView;
        headerView.time.text = getSectionName(section: section);
        
        return headerView;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(EventTableViewCell), forIndexPath: indexPath) as! EventTableViewCell

        let timeSection = eventTimeSections[indexPath.section]
        let event = eventsPerTimeSection[timeSection]![indexPath.row]
        cell.setEvent(event)
        cell.delegate = self

        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]![indexPath.row];
        performSegueWithIdentifier("EventsToEventSegue", sender: event);
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]?[indexPath.row];
        
        let addToFavorite = UITableViewRowAction(style: .Normal, title: "הוסף") { action, index in
            tableView.setEditing(false, animated: true);
            let timeSection = self.eventTimeSections[index.section];
            if let event = self.eventsPerTimeSection[timeSection]?[index.row] {
                event.attending = true;
                TTGSnackbar(message: "האירוע התווסף לאירועים שלי", duration: TTGSnackbarDuration.Short, superView: self.view).show();
                // Reloading all data, since there might be a need to update the indicator in multiple cells (e.g. for multi-hour event)
                tableView.reloadData();
            }
        }
        addToFavorite.backgroundColor = event?.color;
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            let timeSection = self.eventTimeSections[index.section];
            if let event = self.eventsPerTimeSection[timeSection]?[index.row] {
                event.attending = false;
                TTGSnackbar(message: "האירוע הוסר מהאירועים שלי", duration: TTGSnackbarDuration.Short, superView: self.view).show();
                // Reloading all data, since there might be a need to update the indicator in multiple cells (e.g. for multi-hour event)
                tableView.reloadData();
            }
        }
        removeFromFavorite.backgroundColor = event?.color;
        
        return event?.attending == true ? [removeFromFavorite] : [addToFavorite];
    }
    
    
    // MARK: - EventCellState Protocol
    
    func changeFavoriteStateWasClicked(caller: EventTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(caller) else {
            return;
        }
        
        let timeSection = self.eventTimeSections[indexPath.section];
        let event = self.eventsPerTimeSection[timeSection]![indexPath.row];
        event.attending = !event.attending;
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.Short, superView: view).show();
        
        // Reloading all data, since there might be a need to update the indicator in multiple cells (e.g. for multi-hour event)
        tableView.reloadData();
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as? EventViewController;
        eventViewController?.event = sender as! ConventionEvent;
    }
    
    // MARK: - Search Controller delegate
    
    func willPresentSearchController(searchController: UISearchController) {
        tabBarController?.tabBar.hidden = true
        edgesForExtendedLayout = .Bottom // needed otherwise a gap is left where the empty tab bar was
        tableViewController.refreshControl = nil
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.tabBarController?.tabBar.hidden = false
        edgesForExtendedLayout = .None
        addRefreshController()
    }
    
    // MARK: - Private methods
    
    private func calculateEventsAndTimeSections() {
        var result = Dictionary<NSDate, Array<ConventionEvent>>()
        
        let eventsForSelectedDate =
            Convention.instance.events.getAll()
                .filter({$0.startTime.clearTimeComponent().timeIntervalSince1970 == dateFilterControl.selectedDate.timeIntervalSince1970})
        
        let dailyEventsFilteredByCategory = eventsForSelectedDate.filter({event in

            for enabledCategory in enabledCategories {
                if enabledCategory.containsCategory(event.type.description) {
                    return true
                }
            }
            
            return false
        })
        
        var textFilteredEvents = dailyEventsFilteredByCategory
        if let searchText = searchController.searchBar.text where searchController.active && searchText != "" {
            textFilteredEvents = textFilteredEvents.filter({event in
                if let lecturer = event.lecturer where lecturer.containsString(searchText) {
                    return true
                }
                
                return event.title.containsString(searchText)
                    || event.hall.name.containsString(searchText)
            })
        }
        
        for event in textFilteredEvents {

            let roundedEventTime = event.startTime.clearMinutesComponent()
            if (result[roundedEventTime] == nil) {
                result[roundedEventTime] = [event];
            } else {
                result[roundedEventTime]!.append(event);
            }
        }
        
        for time in result.keys {
            result[time]!.sortInPlace({$0.hall.order < $1.hall.order})
        }
        
        eventsPerTimeSection = result;
        eventTimeSections = eventsPerTimeSection.keys.sort({$0.timeIntervalSince1970 < $1.timeIntervalSince1970});
    }
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    func refresh() {
        Convention.instance.events.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing()
            
            GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("PullToRefresh",
                action: "RefreshProgramme",
                label: "",
                value: success ? 1 : 0)
                .build() as [NSObject: AnyObject]);
            
            if (!success) {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.Middle, superView: self.view).show();
                return;
            }
            
            self.tableView.reloadData();
        });
    }
    
    private func getSectionName(section section: Int) -> String? {
        let timeSection = eventTimeSections[section];
        return timeSection.format("HH:mm");
    }
    
    private func addRefreshController() {
        // Adding a tableViewController for hosting a UIRefreshControl.
        // Without a table controller the refresh control causes weird UI issues (e.g. wrong handling of
        // sticky section headers).
        tableViewController.tableView = tableView;
        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.tintColor = UIColor(hexString: "#7a3d59")
        tableViewController.refreshControl?.addTarget(self, action: #selector(EventsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        addChildViewController(tableViewController)
        tableViewController.didMoveToParentViewController(self)
    }
    
    private func addSearchController() {
        searchController.searchBar.barTintColor = Colors.eventTimeHeaderColor
        searchController.searchBar.searchBarStyle = .Default
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func getSectionIndex(forDate forDate: NSDate) -> Int? {
        var index = 0
        let timeToSearchFor = forDate.clearMinutesComponent()
        for timeSection in eventTimeSections {
            if timeSection.timeIntervalSince1970 == timeToSearchFor.timeIntervalSince1970 {
                return index
            }
            index += 1
        }
        
        return nil
    }
}
