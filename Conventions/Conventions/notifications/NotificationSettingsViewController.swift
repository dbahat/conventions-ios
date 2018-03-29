//
//  NotificationSettings.swift
//  Conventions
//
//  Created by David Bahat on 8/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationSettingsViewController: BaseViewController {
    @IBOutlet private weak var generalCategoryButton: UISwitch!
    @IBOutlet private weak var eventsCategoryButton: UISwitch!
    @IBOutlet private weak var cosplayCategoryButton: UISwitch!
    @IBOutlet private weak var busCategoryButton: UISwitch!
    @IBOutlet private weak var developerOptionsButton: UISwitch!
    
    @IBOutlet private weak var eventNotificationButton: UISwitch!
    @IBOutlet private weak var feedbackNotificationButton: UISwitch!
    
    @IBOutlet private weak var developerOptionsContainer: UIView!
    @IBOutlet private weak var developerOptionsContainerHeightConstraint: NSLayoutConstraint!
    
    private var debugOptionsSwitchTapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeButtonsState()
        navigationItem.title = "הגדרות"
    }
    
    @IBAction private func generalNotificationsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_GENERAL, sender: sender)
    }
    
    @IBAction private func eventsNotificationsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_EVENTS, sender: sender)
    }
    
    @IBAction func developerOptionsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_TEST, sender: sender)
    }
    
    @IBAction private func beforeEventNotificationsTapped(_ sender: UISwitch) {
        NotificationSettings.instance.eventStartingReminder = sender.isOn
        
        let favoriteEvents = Convention.instance.events.getAll().filter({$0.attending})
        for event in favoriteEvents {
            if sender.isOn {
                NotificationsSchedualer.scheduleEventAboutToStartNotification(event)
            } else {
                NotificationsSchedualer.removeEventAboutToStartNotification(event)
            }
        }
        
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Notifications",
            action: sender.isOn ? "PreferenceSelected" : "PreferenceDeselected",
            label: Convention.name.lowercased() + "_event_starting_reminder",
            value: NSNumber())
            .build() as! [AnyHashable: Any]);
    }

    @IBAction private func afterEventNotificationsTapped(_ sender: UISwitch) {
        NotificationSettings.instance.eventFeedbackReminder = sender.isOn

        let favoriteEvents = Convention.instance.events.getAll().filter({$0.attending})
        for event in favoriteEvents {
            if sender.isOn {
                NotificationsSchedualer.scheduleEventFeedbackReminderNotification(event)
            } else {
                NotificationsSchedualer.removeEventFeedbackReminderNotification(event)
            }
        }
        
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Notifications",
            action: sender.isOn ? "PreferenceSelected" : "PreferenceDeselected",
            label: Convention.name.lowercased() + "_event_feedback_reminder",
            value: NSNumber())
            .build() as! [AnyHashable: Any]);
    }

    @IBAction private func
        debugOptionsSwitchWasTapped(_ sender: UITapGestureRecognizer) {
            debugOptionsSwitchTapCount = debugOptionsSwitchTapCount + 1
            if debugOptionsSwitchTapCount == 7 {
                NotificationSettings.instance.developerOptionsEnabled = true
                developerOptionsContainerHeightConstraint.constant = 132
                developerOptionsContainer.isHidden = false
            }
    }
    
    
    private func initializeButtonsState() {
        let registeredCategories = NotificationSettings.instance.categories
        generalCategoryButton.isOn = registeredCategories.contains(NotificationHubInfo.CATEGORY_GENERAL)
        eventsCategoryButton.isOn = registeredCategories.contains(NotificationHubInfo.CATEGORY_EVENTS)
        developerOptionsButton.isOn = registeredCategories.contains(NotificationHubInfo.CATEGORY_TEST)
        
        eventNotificationButton.isOn = NotificationSettings.instance.eventStartingReminder
        feedbackNotificationButton.isOn = NotificationSettings.instance.eventFeedbackReminder
        
        if NotificationSettings.instance.developerOptionsEnabled {
            developerOptionsContainerHeightConstraint.constant = 132
            developerOptionsContainer.isHidden = false
        } else {
            developerOptionsContainerHeightConstraint.constant = 0
            developerOptionsContainer.isHidden = true
        }
    }
    
    private func updateCategoryAndRegister(_ category: String, sender: UISwitch) {
        let isOn = sender.isOn
        var currentCategories = NotificationSettings.instance.categories;
        
        if isOn {
            // in case updating the category fails, we revert the switch to it's previous position.
            // This will cause updateCategoryAndRegister() to be invoked again - if that happens,
            // ignore the request.
            if currentCategories.contains(category) {
                return
            }
            currentCategories.insert(category)
        } else {
            if !currentCategories.contains(category) {
                return
            }
            currentCategories.remove(category)
        }
        
        Convention.instance.notificationRegisterar.register(categories: currentCategories, callback: {success in
            if !success {
                // In case the async operation failed, revert the UI change and show an error indication
                TTGSnackbar(message: "לא ניתן לשנות את ההגדרות. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.short, superView: self.view)
                    .show()
                sender.setOn(!isOn, animated: true)
            } else {
                // after a succesful registration in the hub, persist the new categories
                NotificationSettings.instance.categories = currentCategories
            }
            
            GAI.sharedInstance().defaultTracker.send(
                GAIDictionaryBuilder.createEvent(
                    withCategory: "Notifications",
                    action: isOn ? "CategoryAdded" : "CategoryRemoved",
                    label: category,
                    value: success ? 1 : 0)
                .build() as! [AnyHashable: Any])
        })
    }
}
