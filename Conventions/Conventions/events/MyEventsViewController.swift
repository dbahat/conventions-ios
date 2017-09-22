//
//  MyEventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class MyEventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet fileprivate weak var noEventsLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var tabBarIcon: UITabBarItem!
    @IBOutlet fileprivate weak var dateFilterControl: DateFilterControl!
    
    var shouldScrollToCurrentDateAndTime = true
    private var myEvents: Array<ConventionEvent>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFilterControl.setDates(fromDate: Convention.date, toDate: Convention.endDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Adding to my events will trigger a badge icon to hint the user to click my events.
        // Once clicked we can clear the badge.
        tabBarIcon.badgeValue = nil
        
        reloadMyEvents()
        tableView.reloadData()
        
        scrollToCurrentRunningEventsIfNeeded()
    }
    
    private func scrollToCurrentRunningEventsIfNeeded() {
        if !Convention.instance.isRunning() || !shouldScrollToCurrentDateAndTime {
            return
        }
        
        dateFilterControl.selectDate(Date.now())
        reloadMyEvents()
        tableView.reloadData()
        
        // If the convention is currently taking place, auto-scroll to the correct event.
        // Dispatching to the next layout pass so the user will see the scroll animation
        tableView.layoutIfNeeded()
        DispatchQueue.main.async {

            if let currentEventIndex = self.myEvents?.index(where: {$0.startTime.timeIntervalSince1970 >= Date.now().timeIntervalSince1970}) {
                self.tableView.scrollToRow(
                    at: IndexPath(row: currentEventIndex, section: 0),
                    at: .top,
                    animated: true)
                
                // only scroll once (or when set to scroll from externally)
                self.shouldScrollToCurrentDateAndTime = false
            }
        }
    }
    
    @IBAction func dateFilterWasTapped(_ sender: DateFilterControl) {
        reloadMyEvents()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents != nil ? myEvents!.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as! EventTableViewCell
        
        let event = myEvents![indexPath.row]
        cell.setEvent(event)
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let removeFromFavorite = UITableViewRowAction(style: .normal, title: "הסר") { action, index in
            tableView.setEditing(false, animated: true);
            if let event = self.myEvents?[index.row] {
                event.attending = false;
                self.reloadMyEvents();
                tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic);
            }
        }
        let event = self.myEvents?[indexPath.row];
        removeFromFavorite.backgroundColor = event?.color;
        
        return [removeFromFavorite];
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = myEvents?[indexPath.row] {
            performSegue(withIdentifier: "MyEventsToEventSegue", sender: event);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventViewController = segue.destination as! EventViewController;
        eventViewController.event = sender as! ConventionEvent;
    }
    
    func changeFavoriteStateWasClicked(_ caller: EventTableViewCell) {
        guard let indexPath = tableView.indexPath(for: caller) else {
            return;
        }
        guard let event = myEvents?[indexPath.row] else {
            return;
        }
        
        let alertController = UIAlertController(title: "אזהרה", message: "אתה עומד להסיר את האירוע מהאירועים שלי. האם אתה בטוח?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "בטל", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in }
        let okAction = UIAlertAction(title: "אשר", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in

            event.attending = false;
            self.reloadMyEvents();
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic);
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func reloadMyEvents() {
        myEvents = Convention.instance.events.getAll()
            .filter { event in event.attending && event.startTime.clearTimeComponent().timeIntervalSince1970 == dateFilterControl.selectedDate.timeIntervalSince1970 }
            .sorted { $0.startTime.timeIntervalSince1970 < $1.startTime.timeIntervalSince1970};
        
        if (myEvents == nil || myEvents?.count == 0) {
            tableView.isHidden = true;
            noEventsLabel.isHidden = false;
        } else {
            tableView.isHidden = false;
            noEventsLabel.isHidden = true;
        }
    }
}
