//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, EventStateProtocol {

    override func viewDidLoad() {
        super.viewDidLoad();

        let eventViewCell = UINib(nibName: "EventTableViewCell", bundle: nil);
        self.tableView.registerNib(eventViewCell, forCellReuseIdentifier: "EventTableViewCell");
        
        let eventHeaderView = UINib(nibName: "EventListHeaderView", bundle: nil);
        self.tableView.registerNib(eventHeaderView, forHeaderFooterViewReuseIdentifier: "EventListHeaderView");
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Convention.instance.events.count;
    }
    
    func getSectionName(section section: Int) -> String? {
        switch section {
        case 0:
            return "10:00"
        case 1:
            return "11:00"
        case 2:
            return "12:00"
        case 3:
            return "13:00"
        default:
            return "14:00"
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("EventListHeaderView") as! EventListHeaderView;
        headerView.time.text = getSectionName(section: section);
        
        return headerView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell

        let event = Convention.instance.events[indexPath.row];
        cell.setEvent(event);
        cell.favoriteButton.tag = indexPath.row;
        cell.delegate = self;

        return cell;
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
            let event = Convention.instance.events[index.row];
            event.attending = true;
            tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
        }
        addToFavorite.backgroundColor = UIColor.redColor();
        
        let removeFromFavorite = UITableViewRowAction(style: .Normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            let event = Convention.instance.events[index.row];
            event.attending = false;
            tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.None);
        }
        removeFromFavorite.backgroundColor = UIColor.redColor();
        
        let event = Convention.instance.events[indexPath.row];
        return event.attending ? [removeFromFavorite] : [addToFavorite];
    }
}
