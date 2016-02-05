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
        
        let eventViewCell = UINib(nibName: "EventView", bundle: nil);
        self.tableView.registerNib(eventViewCell, forCellReuseIdentifier: "EventView");
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

        let headerView = NSBundle.mainBundle().loadNibNamed("EventListHeaderView", owner: 0, options: nil)[0] as? EventListHeaderView;
        headerView?.time.text = getSectionName(section: section);
        
        return headerView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventView", forIndexPath: indexPath) as! EventTableViewCell

        let event = Convention.instance.events[indexPath.row];
        cell.startTime.text = NSCalendar.currentCalendar().components([.Hour], fromDate: event.startTime).hour.description + ":00";
        cell.endTime.text = NSCalendar.currentCalendar().components([.Hour], fromDate: event.startTime).hour.description + ":00";
        cell.title.text = event.title;
        cell.lecturer.text = event.lecturer;
        cell.hallName.text = event.hall.name;
        cell.timeLayout.backgroundColor = UIColor.redColor(); // event.getColor

        let favoriteImage = event.attending ? UIImage(named: "EventAttending") : UIImage(named: "EventNotAttending");
        cell.favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal);
        cell.favoriteButton.tag = indexPath.row;
        cell.delegate = self;

        return cell;
    }
    
    func changeFavoriteStateWasClicked(caller: EventTableViewCell) {
        let rowIndex = caller.tag;
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
