//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate, SearchCategoriesProtocol, UISearchResultsUpdating, UISearchControllerDelegate, UIScrollViewDelegate {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var noResultsFoundLabel: UILabel!

    fileprivate var eventsPerTimeSection: Dictionary<Date, Array<ConventionEvent>> = [:]
    fileprivate var eventTimeSections: Array<Date> = []
    
    var shouldScrollToCurrentDateAndTime = true

    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    fileprivate let tableViewController = UITableViewController()
    
    fileprivate var enabledCategories: Array<AggregatedSearchCategory> = [.lectures, .games, .workshops, .others]
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet fileprivate weak var dateFilterControl: DateFilterControl!
    
    @IBOutlet fileprivate weak var searchCategoriesLayout: SearchCategoriesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let eventHeaderView = UINib(nibName: String(describing: EventListHeaderView.self), bundle: nil)
        self.tableView.register(eventHeaderView, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        
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
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // redraw the table when navigating in/out of the view, in case the model changed
        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            // Disabling search during orientation/size changes since the search control seem to have issues when orientation changes 
            // (suddenly appearing in the wrong position).
            self.searchController.isActive = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToCurrentRunningEventsIfNeeded()
    }
    
    fileprivate func scrollToCurrentRunningEventsIfNeeded() {
        if !Convention.instance.isRunning() || !shouldScrollToCurrentDateAndTime {
            return
        }
        
        dateFilterControl.selectDate(Date.now())
        calculateEventsAndTimeSections()
        tableView.reloadData()
        
        // If the convention is currently taking place, auto-scroll to the correct time section.
        // Dispatching to the next layout pass so the user will see the scroll animation
        tableView.layoutIfNeeded()
        DispatchQueue.main.async {
            if let sectionIndex = self.getSectionIndex(forDate: Date.now()) {
                self.tableView.scrollToRow(
                    at: IndexPath(row: 0, section: sectionIndex),
                    at: .top,
                    animated: true)
                
                // only scroll once (or when set to scroll from externally)
                self.shouldScrollToCurrentDateAndTime = false
            }
        }
    }
    
    @IBAction func dateFilterTapped(_ sender: UISegmentedControl) {
        calculateEventsAndTimeSections()
        tableView.reloadData()
        
        if eventTimeSections.count > 0 {
            // reset the scroll state when changing days for better user experiance
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func filterSearchCategoriesChanged(_ enabledCategories: Array<AggregatedSearchCategory>) {
        self.enabledCategories = enabledCategories

        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return eventTimeSections.count;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timeSection = eventTimeSections[section];
        return eventsPerTimeSection[timeSection]!.count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: EventListHeaderView.self)) as! EventListHeaderView;
        headerView.time.text = getSectionName(section: section);
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as! EventTableViewCell

        let timeSection = eventTimeSections[indexPath.section]
        let event = eventsPerTimeSection[timeSection]![indexPath.row]
        cell.setEvent(event)
        cell.delegate = self

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]![indexPath.row];
        performSegue(withIdentifier: "EventsToEventSegue", sender: event);
    }
    
    // MARK: - EventCellState Protocol
    
    func changeFavoriteStateWasClicked(_ caller: EventTableViewCell) {
        guard let indexPath = tableView.indexPath(for: caller) else {
            return;
        }
        
        let timeSection = self.eventTimeSections[indexPath.section];
        let event = self.eventsPerTimeSection[timeSection]![indexPath.row];
        event.attending = !event.attending;
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.short, superView: view).show();
        
        // Reloading all data, since there might be a need to update the indicator in multiple cells (e.g. for multi-hour event)
        tableView.reloadData();
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventViewController = segue.destination as? EventViewController;
        eventViewController?.event = sender as! ConventionEvent;
    }
    
    // MARK: - Search Controller delegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = .bottom // needed otherwise a gap is left where the empty tab bar was
        
        view.backgroundColor = Colors.eventEndedColor
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = false
        edgesForExtendedLayout = UIRectEdge()
        
        view.backgroundColor = UIColor.white
    }
    
    // MARK: - UIScrollView delegate
    
    // Needed so the events can be invisible when scrolled behind the sticky header.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            let hiddenFrameHeight = scrollView.contentOffset.y + navigationController!.navigationBar.frame.size.height - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let customCell = cell as? EventTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func calculateEventsAndTimeSections() {
        var result = Dictionary<Date, Array<ConventionEvent>>()
        
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
        if let searchText = searchController.searchBar.text, searchController.isActive && searchText != "" {
            textFilteredEvents = textFilteredEvents.filter({event in
                if let lecturer = event.lecturer, lecturer.contains(searchText) {
                    return true
                }
                
                return event.title.contains(searchText)
                    || event.hall.name.contains(searchText)
            })
        }
        
        for event in textFilteredEvents {

            let roundedEventTime = event.startTime.clearMinutesComponent()
            if (result[roundedEventTime as Date] == nil) {
                result[roundedEventTime as Date] = [event];
            } else {
                result[roundedEventTime as Date]!.append(event);
            }
        }
        
        for time in result.keys {
            result[time]!.sort(by: {$0.hall.order < $1.hall.order})
        }
        
        eventsPerTimeSection = result;
        eventTimeSections = eventsPerTimeSection.keys.sorted(by: {$0.timeIntervalSince1970 < $1.timeIntervalSince1970});
        
        noResultsFoundLabel.isHidden = eventsPerTimeSection.count > 0
    }
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    func refresh() {
        
        if searchController.isActive {
            tableViewController.refreshControl?.endRefreshing()
            return
        }
        
        Convention.instance.events.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing()
            
            GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "PullToRefresh",
                                                                                      action: "RefreshProgramme",
                                                                                      label: "",
                                                                                      value: success ? 1 : 0)
                .build() as! [AnyHashable : Any]!);
            
            if (!success) {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.middle, superView: self.view).show();
                return;
            }
            
            self.tableView.reloadData();
        });
    }
    
    fileprivate func getSectionName(section: Int) -> String? {
        let timeSection = eventTimeSections[section];
        return timeSection.format("HH:mm");
    }
    
    fileprivate func addRefreshController() {
        // Adding a tableViewController for hosting a UIRefreshControl.
        // Without a table controller the refresh control causes weird UI issues (e.g. wrong handling of
        // sticky section headers).
        tableViewController.tableView = tableView;
        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.tintColor = Colors.colorAccent
        tableViewController.refreshControl?.addTarget(self, action: #selector(EventsViewController.refresh), for: UIControlEvents.valueChanged)
        tableViewController.refreshControl?.backgroundColor = UIColor(hexString: "#A6B6B3")
        addChildViewController(tableViewController)
        tableViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func addSearchController() {
        searchController.searchBar.barTintColor = Colors.eventTimeHeaderColor
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    fileprivate func getSectionIndex(forDate: Date) -> Int? {
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
