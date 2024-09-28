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
    @IBOutlet private weak var progressBarView: UIView!
    @IBOutlet private weak var importingTicketsLabel: UILabel!
    @IBOutlet private weak var toastView: UIView!
    
    var shouldScrollToCurrentDateAndTime = true
    private var myEvents: Array<ConventionEvent>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFilterControl.setDates(fromDate: Convention.date, toDate: Convention.endDate)
        
        noEventsLabel.textColor = Colors.hintTextColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Adding to my events will trigger a badge icon to hint the user to click my events.
        // Once clicked we can clear the badge.
        tabBarIcon.badgeValue = nil
        
        reloadMyEvents()
        tableView.reloadData()
        progressBarView.isHidden = true
        progressBarView.backgroundColor = Colors.white
        importingTicketsLabel.textColor = Colors.black
        
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

            if let currentEventIndex = self.myEvents?.firstIndex(where: {$0.startTime.timeIntervalSince1970 >= Date.now().timeIntervalSince1970}) {
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
                tableView.deleteRows(at: [index], with: UITableView.RowAnimation.automatic);
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
        
        let alertController = UIAlertController(title: "אזהרה", message: "אתה עומד להסיר את האירוע מהאירועים שלי. האם אתה בטוח?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "בטל", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in }
        let okAction = UIAlertAction(title: "אשר", style: UIAlertAction.Style.destructive) { (result : UIAlertAction) -> Void in

            event.attending = false;
            self.reloadMyEvents();
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic);
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func importEventsWasClicked(_ sender: UIBarButtonItem) {

        self.progressBarView.isHidden = false
        
        UserTicketsRetriever().retrieve(caller: self, callback: {(importedEvents, error) in
            
            self.progressBarView.isHidden = true
            
            if error != nil {
                TTGSnackbar(message: "ארעה שגיאה בהתחברות. נסה שנית מאוחר יותר.", duration: TTGSnackbarDuration.middle, superView: self.toastView).show()
                return
            }
            
            let newlyImportedEvents = Convention.instance.events.getAll()
                .filter({event in importedEvents.eventIds.contains(event.serverId) && !event.attending})
            for event in newlyImportedEvents {
                event.attending = true
            }
            self.reloadMyEvents()
            self.tableView.reloadData()
            
            UserDefaults.standard.set(importedEvents.userId, forKey: "userId")
            UserDefaults.standard.set(importedEvents.email, forKey: "email")
            UserDefaults.standard.set(importedEvents.qrData, forKey: "qrData")
                            
            self.showImportedTicketsViewController(userId: importedEvents.userId, email: importedEvents.email, numberOfImported: newlyImportedEvents.count, qrData: importedEvents.qrData)
        })
    }
    
    private func logout() {
        UserTicketsRetriever.logout()
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "email")
    }
    
    @IBAction func showQrWasClicked(_ sender: UIBarButtonItem) {
        guard
            var userId = UserDefaults.standard.string(forKey: "userId"),
            let email = UserDefaults.standard.string(forKey: "email")
        else {
            // in case there's stored user data show the import events dialog
            importEventsWasClicked(sender)
            return
        }
        
        showImportedTicketsViewController(userId: userId, email: email)
    }
    
    private func showImportedTicketsViewController(userId: String, email: String, numberOfImported: Int? = nil, qrData: Data? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImportedTicketsViewController") as! ImportedTicketsViewController
        
        var topLabelMessage = ""
        if let imported = numberOfImported {
            topLabelMessage = topLabelMessage + "אירועים שנקלטו מהאתר: \(imported)\n\n"
        }
        topLabelMessage = topLabelMessage + "הצג את קוד ה-QR בקופות העצמאיות עבור איסוף מהיר של הכרטיסים."
                
        controller.topLabel = topLabelMessage
        controller.midLabel = "שם משתמש: \(email)"
        
        if userId != "" && qrData != nil {
            controller.bottomLabel = "מספר משתמש: \(userId)"
            controller.shouldHideUpdatesButtonImage = true
        } else {
            controller.bottomLabel = "קנית כרטיסים? רענן כדי להציג QR ומספר משתמש"
        }
        
        controller.onRefreshClicked = {
            // At this point the controller was already created so we can access it's outlet directory
            controller.importedTickets.updatesButtonImage.startRotate()
            UserTicketsRetriever().retrieve(caller: self, callback: {(importedEvents, error) in
                controller.importedTickets.updatesButtonImage.stopRotate()
                if (importedEvents.userId != "") {
                    controller.importedTickets.bottomLabel.text = "מספר משתמש: \(importedEvents.userId)"
                    controller.importedTickets.updatesButtonImage.isHidden = true
                }
                if let qr = importedEvents.qrData {
                    controller.image = UIImage(data: qr)
                }
            })
        }
        controller.onLogoutClicked = {
            self.logout()
            controller.dismiss(animated: true)
        }
        if let qrData = UserDefaults.standard.data(forKey: "qrData") {
            controller.image = UIImage(data: qrData)
        }

        controller.modalPresentationStyle = .formSheet
        if let popover = controller.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = self.view.bounds
            popover.permittedArrowDirections = []

        }
        
        self.present(controller, animated: true, completion: nil)
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
