//
//  MyEventsTableViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class MyEventsViewController: BaseViewController, EventCellStateProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var noEventsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tabBarIcon: UITabBarItem!
    @IBOutlet private weak var dateFilterControl: DateFilterControl!
    
    var shouldScrollToCurrentDateAndTime = true
    private var myEvents: Array<ConventionEvent>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFilterControl.setDates(fromDate: Convention.date, toDate: Convention.endDate)
        
        noEventsLabel.textColor = Colors.eventNotStartedColor
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
        eventViewController.event = (sender as! ConventionEvent);
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
    
    @IBAction func importEventsWasClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "הוספת אירועים מאתר אייקון", message: "הכנס שם משתמש וסיסמא לאתר אייקון על מנת להוסיף את האירועים להם קנית כרטיסים מראש ולהציג את מספר המשתמש שלך.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "בטל", style: .cancel) { (result : UIAlertAction) -> Void in }
        let okAction = UIAlertAction(title: "הוסף", style: .default) { (result : UIAlertAction) -> Void in
            guard
                let user = alertController.textFields![0].text,
                let password = alertController.textFields![1].text
            else {
                return
            }
            
            if (user.isEmpty || !user.contains("@")) {
                TTGSnackbar(message: "שם משתמש לא תקין", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                return
            }
            
            UserTicketsRetriever().retrieve(user: user, password: password, callback: {(importedEvents, error) in
                if let failureReason = error {
                    switch failureReason {
                    case .badPassword:
                        TTGSnackbar(message: "שם משתמש או סיסמה לא נכונים", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                    case .badUsername:
                        TTGSnackbar(message: "שם משתמש לא חוקי", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                    case .unknown:
                        TTGSnackbar(message: "ייבוא האירועים נכשל. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                    }
                    
                    return
                }
                
                let newlyImportedEvents = Convention.instance.events.getAll()
                    .filter({event in importedEvents.eventIds.contains(event.serverId) && !event.attending})
                for event in newlyImportedEvents {
                    event.attending = true
                }
                self.reloadMyEvents()
                
                var numberOfAddedEventsMessgae: String
                if newlyImportedEvents.count == 1 {
                    numberOfAddedEventsMessgae = "נוסף אירוע אחד"
                } else if newlyImportedEvents.count == 0 {
                    numberOfAddedEventsMessgae = "לא נוספו אירועים"
                } else {
                    numberOfAddedEventsMessgae = String(format: "נוספו %d אירועים.\n\n", newlyImportedEvents.count)
                }
                
                UserDefaults.standard.set(importedEvents.userId, forKey: "userId")
                
                let message =
                    numberOfAddedEventsMessgae + "\n" +
                    String(format: "מספר המשתמש שלך הוא \n%@\n\n",importedEvents.userId)
                    + "הצג את מספר המשתמש שלך בקופות עבור איסוף מהיר של הכרטיסים.\n ניתן לגשת למספר ע״י לחיצה על הכפתור ׳מספר משתמש׳ בפינה השמאלית העליונה של המסך"
                let alertController = UIAlertController(title: nil,
                                                        message: message,
                                                        preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "אישור", style: .cancel) { (result : UIAlertAction) -> Void in }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
        alertController.addTextField(configurationHandler: {textField in
            textField.textAlignment = .right
            textField.placeholder = "שם משתמש"
            textField.keyboardType = .emailAddress
        })
        alertController.addTextField(configurationHandler: {textField in
            textField.isSecureTextEntry=true
            textField.textAlignment = .right
            textField.placeholder = "סיסמה"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showUserIdWasClicked(_ sender: UIBarButtonItem) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            // in case there's no user ID set yet, show the import events dialog
            importEventsWasClicked(sender)
            return
        }
        
        let alertController = UIAlertController(title: nil,
                                                message: String(format: "מספר המשתמש שלך הוא \n\n%@",userId),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "אישור", style: .cancel) { (result : UIAlertAction) -> Void in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
