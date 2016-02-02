//
//  EventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 1/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let label = UILabel();
        label.textAlignment = NSTextAlignment.Center;
        label.backgroundColor = UIColor.grayColor();
        label.text = getSectionName(section: section);
        
        return label;
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

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let favorite = UITableViewRowAction(style: .Normal, title: "הוסף") { action, index in
            print("favorite button tapped")
            
        }
        favorite.backgroundColor = UIColor.redColor()
        favorite.backgroundEffect = UIBlurEffect(style: UIBlurEffectStyle.Light);
        
        return [favorite]
    }
}
