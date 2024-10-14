//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class EventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate, SearchCategoriesProtocol, UIScrollViewDelegate, UISearchBarDelegate {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var noResultsFoundLabel: UILabel!
    @IBOutlet private weak var toastBar: UIView!
    
    fileprivate var eventsPerTimeSection: Dictionary<Date, Array<ConventionEvent>> = [:]
    fileprivate var eventTimeSections: Array<Date> = []
    
    var shouldScrollToCurrentDateAndTime = true

    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    fileprivate let tableViewController = UITableViewController()
    
    fileprivate var enabledCategories: Array<AggregatedSearchCategory> = [.lectures, .shows, .workshops, .others]
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet fileprivate weak var dateFilterControl: DateFilterControl!
    
    @IBOutlet fileprivate weak var searchCategoriesLayout: SearchCategoriesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        let eventHeaderView = UINib(nibName: String(describing: EventListHeaderView.self), bundle: nil)
        self.tableView.register(eventHeaderView, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        
        addRefreshController()
        initializeSearchBar()
        
        dateFilterControl.setDates(fromDate: Convention.date, toDate: Convention.endDate)
        searchCategoriesLayout.delegate = self
        
        // TODO - only perform this if an hour has passed since last refresh
        Convention.instance.events.refresh({success in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Drawing the table here and not viewDidLoad, since the layout cycle needs to complete before we draw the cells
        calculateEventsAndTimeSections()
        tableView.reloadData()
        
        if eventTimeSections.count > 0 && UIDevice.current.userInterfaceIdiom == .phone {
            // Hide the search bar during page initial load.
            // Disabled for tablets since on iOS 11 tablets this seems to distort the UI.
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        noResultsFoundLabel.textColor = Colors.textColor
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
        // Needed in case the dequeued cell was masked by the stickey header
        cell.maskCell(fromTop: 0)

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
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.short, superView: toastBar).show();
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventViewController = segue.destination as? EventViewController;
        eventViewController?.event = (sender as! ConventionEvent);
    }
    
    // MARK: - UIScrollView delegate
    
    // Needed so the events can be invisible when scrolled behind the sticky header.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            let maskMargin = 16.0 // Have a mask slightly bigger then the header as a margin
            let hiddenFrameHeight = scrollView.contentOffset.y + navigationController!.navigationBar.frame.size.height - cell.frame.origin.y + maskMargin
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let customCell = cell as? EventTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
    }
    
    // MARK: - UISearchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        calculateEventsAndTimeSections()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func applyFiltersForEvents(_ events: Array<ConventionEvent>) -> Array<ConventionEvent> {
        let dailyEventsFilteredByCategory = events.filter({event in
            
            for enabledCategory in enabledCategories {
                if enabledCategory.containsCategory(event.type.description) {
                    return true
                }
            }
            
            return false
        })
        
        var textFilteredEvents = dailyEventsFilteredByCategory
        if let searchText = searchBar.text, searchText != "" {
            textFilteredEvents = textFilteredEvents.filter({event in
                if let lecturer = event.lecturer, lecturer.contains(searchText) {
                    return true
                }
                
                return event.title.contains(searchText)
                    || event.hall.name.contains(searchText)
                    || event.tags.contains(searchText)
            })
        }
        
        return textFilteredEvents
    }
    
    fileprivate func calculateEventsAndTimeSections() {
        var result = Dictionary<Date, Array<ConventionEvent>>()
        
        let eventsForSelectedDate =
            Convention.instance.events.getAll()
                .filter({$0.startTime.clearTimeComponent() == dateFilterControl.selectedDate})
        
        let filteredEvents = applyFiltersForEvents(eventsForSelectedDate)
        
        for event in filteredEvents {
            
            if event.isOngoing {
                var currentDate = event.startTime.clearMinutesComponent()
                while currentDate <= event.endTime.clearMinutesComponent() {
                    if (result[currentDate] == nil) {
                        result[currentDate] = [event];
                    } else {
                        result[currentDate]!.append(event);
                    }
                    currentDate = currentDate.addHours(1)
                }
                
                continue ;
            }

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
        eventTimeSections = eventsPerTimeSection.keys.sorted(by: {$0 < $1});
        
        noResultsFoundLabel.isHidden = eventsPerTimeSection.count > 0
        
        let numberOfEventsPerDay = Dictionary(grouping: Convention.instance.events.getAll(), by: { $0.startTime.clearTimeComponent() })
            .sorted(by: { (current, other) -> Bool in
                current.key > other.key
            })
            .map({ applyFiltersForEvents($0.value).count })

        if let searchText = searchBar.text, searchText != "" {
            dateFilterControl.updateNumberOfResultsPerSegment(numberOfEventsPerDay)
        } else {
            dateFilterControl.resetNumberOfResults()
        }
    }
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    @objc func refresh() {
        
        Convention.instance.events.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing()
            
            Analytics.logEvent("PullToRefresh", parameters: [
                "name": "RefreshProgramme" as NSObject,
                "success": success as NSObject
                ])
            
            if (!success) {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.middle, superView: self.toastBar).show();
                return;
            }
            
            self.calculateEventsAndTimeSections()
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
        tableViewController.refreshControl?.addTarget(self, action: #selector(EventsViewController.refresh), for: UIControl.Event.valueChanged)
        tableViewController.refreshControl?.backgroundColor = UIColor.clear
    }
    
    fileprivate func initializeSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.tintColor = Colors.eventSearchBarTextColor
        searchBar.delegate = self
        searchBar.semanticContentAttribute = .forceRightToLeft
        searchBar.layer.backgroundColor = Colors.clear.cgColor

        
        var searchTextField: UITextField
        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
             searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        }
        searchTextField.textAlignment = .right
        searchTextField.textColor = Colors.eventSearchBarTextColor
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
