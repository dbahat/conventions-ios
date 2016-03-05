//
//  MyEventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController, EventCellStateProtocol {
    
    private var myEvents: Array<ConventionEvent>?;
    
    override func viewDidAppear(animated: Bool) {
        reloadMyEvents();
        tableView.reloadData();
        
        // Send an event that the screen was visited. Not taken from BaseViewController since we derive from UITableViewController.
        // Not adding a new base since we probebly won't have more UITableViewControllers.
        let tracker = GAI.sharedInstance().defaultTracker;
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType));
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]);
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents != nil ? myEvents!.count : 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(EventTableViewCell), forIndexPath: indexPath) as! EventTableViewCell
        
        let event = myEvents![indexPath.row];
        cell.setEvent(event);
        cell.delegate = self;

        return cell
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            if let event = self.myEvents?[index.row] {
                event.attending = false;
                self.reloadMyEvents();
                tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic);
            }
        }
        let event = self.myEvents?[indexPath.row];
        removeFromFavorite.backgroundColor = event?.color;
        
        return [removeFromFavorite];
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let event = myEvents?[indexPath.row] {
            performSegueWithIdentifier("MyEventsToEventSegue", sender: event);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as! EventViewController;
        eventViewController.event = sender as! ConventionEvent;
    }
    
    func changeFavoriteStateWasClicked(caller: EventTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(caller) else {
            return;
        }
        guard let event = myEvents?[indexPath.row] else {
            return;
        }
        
        
        event.attending = false;
        reloadMyEvents();
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic);
    }
    
    private func reloadMyEvents() {
        myEvents = Convention.instance.events.getAll()
            .filter { event in event.attending }
            .sort { $0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970};
    }
}
