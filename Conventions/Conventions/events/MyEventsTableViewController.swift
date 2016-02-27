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

    override func viewDidLoad() {
        super.viewDidLoad();
        
        refreshControl = UIRefreshControl();
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadMyEvents();
        tableView.reloadData();
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
        eventViewController.event = sender as? ConventionEvent;
    }
    
    private func reloadMyEvents() {
        myEvents = Convention.instance.events?
            .filter { event in event.attending }
            .sort { $0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970};
    }
    
    func refresh(sender:AnyObject)
    {
        Convention.instance.refresh({
            self.tableView.reloadData();
            self.refreshControl?.endRefreshing();
        })
    }
}
