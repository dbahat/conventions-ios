//
//  MyEventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController, EventStateProtocol {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let eventViewCell = UINib(nibName: "EventTableViewCell", bundle: nil);
        self.tableView.registerNib(eventViewCell, forCellReuseIdentifier: "EventTableViewCell");
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData();
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Convention.instance.favoriteEvents.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell
        
        let event = Convention.instance.favoriteEvents[indexPath.row];
        cell.setEvent(event);
        cell.favoriteButton.tag = indexPath.row;
        cell.delegate = self;

        return cell
    }
    
    func changeFavoriteStateWasClicked(caller: EventTableViewCell) {
        let rowIndex = caller.favoriteButton.tag;
        let event = Convention.instance.favoriteEvents[rowIndex];
        event.attending = false;
        
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: rowIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic);
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            let event = Convention.instance.favoriteEvents[index.row];
            event.attending = false;
            tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic);
        }
        removeFromFavorite.backgroundColor = UIColor.redColor();
        
        return [removeFromFavorite];
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = Convention.instance.events[indexPath.row];
        performSegueWithIdentifier("MyEventsToEventSegue", sender: event);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventViewController = segue.destinationViewController as! EventViewController;
        eventViewController.event = sender as? ConventionEvent;
    }
}
