//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, EventStateProtocol {

    private var eventsPerTimeSection: Dictionary<NSDate, Array<ConventionEvent>>!;
    private var eventTimeSections: Array<NSDate>!;
    
    override func viewDidLoad() {
        super.viewDidLoad();

        let eventViewCell = UINib(nibName: "EventTableViewCell", bundle: nil);
        self.tableView.registerNib(eventViewCell, forCellReuseIdentifier: "EventTableViewCell");
        
        let eventHeaderView = UINib(nibName: "EventListHeaderView", bundle: nil);
        self.tableView.registerNib(eventHeaderView, forHeaderFooterViewReuseIdentifier: "EventListHeaderView");
    }

    override func viewWillAppear(animated: Bool) {
        // redraw the table when navigating in/out of the view, in case the model changed
        eventsPerTimeSection = calculateEventsPerTimeSection();
        eventTimeSections = calculateEventsTimeSections();
        tableView.reloadData();
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventTimeSections.count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timeSection = eventTimeSections[section];
        return eventsPerTimeSection[timeSection]!.count;
    }
    
    private func getSectionName(section section: Int) -> String? {
        let timeSection = eventTimeSections[section];
        return timeSection.format("HH:mm");
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("EventListHeaderView") as! EventListHeaderView;
        headerView.time.text = getSectionName(section: section);
        
        return headerView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell

        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]![indexPath.row];
        cell.setEvent(event);
        cell.favoriteButton.tag = indexPath.row;
        cell.delegate = self;

        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let timeSection = eventTimeSections[indexPath.section];
        let event = eventsPerTimeSection[timeSection]![indexPath.row];
        performSegueWithIdentifier("EventsToEventSegue", sender: event);
    }
    
    func changeFavoriteStateWasClicked(caller: EventTableViewCell) {
        let rowIndex = caller.favoriteButton.tag;
        let event = Convention.instance.events[rowIndex];
        event.attending = !event.attending;
        
        tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let addToFavorite = UITableViewRowAction(style: .Normal, title: "הוסף") { action, index in
            tableView.setEditing(false, animated: true);
            let timeSection = self.eventTimeSections[indexPath.section];
            let event = self.eventsPerTimeSection[timeSection]![indexPath.row];
            event.attending = true;
            tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
        }
        addToFavorite.backgroundColor = UIColor.redColor();
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            let timeSection = self.eventTimeSections[indexPath.section];
            let event = self.eventsPerTimeSection[timeSection]![indexPath.row];
            event.attending = false;
            tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
        }
        removeFromFavorite.backgroundColor = UIColor.redColor();
        
        let event = Convention.instance.events[indexPath.row];
        return event.attending ? [removeFromFavorite] : [addToFavorite];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as! EventViewController;
        eventViewController.event = sender as? ConventionEvent;
    }
    
    // MARK: - Private methods
    
    private func calculateEventsPerTimeSection() -> Dictionary<NSDate, Array<ConventionEvent>> {
        var result = Dictionary<NSDate, Array<ConventionEvent>>();
        
        for event in Convention.instance.events {
            // In case an event lasts more then 1 hour, duplicate them so they'll appear in multiple time sections.
            // e.g. If an event is from 12:00 until 14:00, it should appear in time sections 12:00, 13:00.
            let eventLengthInHours = Int(event.endTime.timeIntervalSinceDate(event.startTime) / 60 / 60);
            for var i = 0; i < eventLengthInHours; i++ {
                let roundedEventTime = event.startTime.clearMinutesComponent().addHours(i);
                if (result[roundedEventTime] == nil) {
                    result[roundedEventTime] = [event];
                } else {
                    result[roundedEventTime]!.append(event);
                }
                
                result[roundedEventTime]!.sortInPlace({$0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970})
            }
        }
        
        return result;
    }
    
    private func calculateEventsTimeSections() -> Array<NSDate>! {
        if (Convention.instance.events == nil) {
            return [];
        }
        
        return Set(Convention.instance.events!.map({event in event.startTime.clearMinutesComponent()}))
            .sort({$0.timeIntervalSince1970 < $1.timeIntervalSince1970});
    }
}
