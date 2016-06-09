//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!

    private var eventsPerTimeSection: Dictionary<NSDate, Array<ConventionEvent>>!;
    private var eventTimeSections: Array<NSDate>!;
    
    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    private let tableViewController = UITableViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad();

        let eventHeaderView = UINib(nibName: String(EventListHeaderView), bundle: nil);
        self.tableView.registerNib(eventHeaderView, forHeaderFooterViewReuseIdentifier: String(EventListHeaderView));
        
        addRefreshControl();
        
        // Make initial model calculation when the view loads
        calculateEventsAndTimeSections();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // redraw the table when navigating in/out of the view, in case the model changed
        calculateEventsAndTimeSections();
        tableView.reloadData();
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

        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]![indexPath.row];
        cell.setEvent(event);
        cell.delegate = self;

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
    
    // MARK: - Private methods
    
    private func calculateEventsAndTimeSections() {
        var result = Dictionary<NSDate, Array<ConventionEvent>>();
        
        for event in Convention.instance.events.getAll() {
            // In case an event lasts more then 1 hour, duplicate them so they'll appear in multiple time sections.
            // e.g. If an event is from 12:00 until 14:00, it should appear in time sections 12:00, 13:00.
            let eventLengthInHours = Int(event.endTime.moveToNextRoundHour().timeIntervalSinceDate(
                event.startTime.clearMinutesComponent()) / 60 / 60);
            for i in 0 ..< eventLengthInHours {
                let roundedEventTime = event.startTime.clearMinutesComponent().addHours(i);
                
                if (result[roundedEventTime] == nil) {
                    result[roundedEventTime] = [event];
                } else {
                    result[roundedEventTime]!.append(event);
                }
                
                result[roundedEventTime]!.sortInPlace({
                    $0.hall.order < $1.hall.order})
            }
        }
        
        eventsPerTimeSection = result;
        eventTimeSections = eventsPerTimeSection.keys.sort({$0.timeIntervalSince1970 < $1.timeIntervalSince1970});
    }
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    func refresh() {
        Convention.instance.events.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing();
            
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
    
    private func addRefreshControl() {
        // Adding a tableViewController for hosting a UIRefreshControl.
        // Without a table controller the refresh control causes weird UI issues (e.g. wrong handling of
        // sticky section headers).
        tableViewController.tableView = tableView;
        tableViewController.refreshControl = UIRefreshControl();
        tableViewController.refreshControl?.addTarget(self, action: #selector(EventsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged);
        addChildViewController(tableViewController);
        tableViewController.didMoveToParentViewController(self);
    }
}
