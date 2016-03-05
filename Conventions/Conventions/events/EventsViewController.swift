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
    private let refreshControl = UIRefreshControl();
    
    override func viewDidLoad() {
        super.viewDidLoad();

        let eventHeaderView = UINib(nibName: String(EventListHeaderView), bundle: nil);
        self.tableView.registerNib(eventHeaderView, forHeaderFooterViewReuseIdentifier: String(EventListHeaderView));
        
        tableView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
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
                tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
                TTGSnackbar(message: "האירוע התווסף לאירועים שלי", duration: TTGSnackbarDuration.Short, superView: self.view).show();
            }
        }
        addToFavorite.backgroundColor = event?.color;
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            let timeSection = self.eventTimeSections[index.section];
            if let event = self.eventsPerTimeSection[timeSection]?[index.row] {
                event.attending = false;
                tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
                TTGSnackbar(message: "האירוע הוסר מהאירועים שלי", duration: TTGSnackbarDuration.Short, superView: self.view).show();
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
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.Short, superView: view)
            .show();
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None);
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as? EventViewController;
        eventViewController?.event = sender as? ConventionEvent;
    }
    
    // MARK: - Private methods
    
    private func calculateEventsAndTimeSections() {
        var result = Dictionary<NSDate, Array<ConventionEvent>>();
        
        for event in Convention.instance.events.getAll() {
            // In case an event lasts more then 1 hour, duplicate them so they'll appear in multiple time sections.
            // e.g. If an event is from 12:00 until 14:00, it should appear in time sections 12:00, 13:00.
            let eventLengthInHours = Int(event.endTime.moveToNextRoundHour().timeIntervalSinceDate(
                event.startTime.clearMinutesComponent()) / 60 / 60);
            for var i = 0; i < eventLengthInHours; i++ {
                let roundedEventTime = event.startTime.clearMinutesComponent().addHours(i);
                
                if (result[roundedEventTime] == nil) {
                    result[roundedEventTime] = [event];
                } else {
                    result[roundedEventTime]!.append(event);
                }
                
                result[roundedEventTime]!.sortInPlace({
                    $0.hall?.order < $1.hall?.order})
            }
        }
        
        eventsPerTimeSection = result;
        eventTimeSections = eventsPerTimeSection.keys.sort({$0.timeIntervalSince1970 < $1.timeIntervalSince1970});
    }
    
    func refresh(sender:AnyObject)
    {
        Convention.instance.events.refresh({
            self.tableView.reloadData();
            self.refreshControl.endRefreshing();
        })
    }
    
    private func getSectionName(section section: Int) -> String? {
        let timeSection = eventTimeSections[section];
        return timeSection.format("HH:mm");
    }
}
