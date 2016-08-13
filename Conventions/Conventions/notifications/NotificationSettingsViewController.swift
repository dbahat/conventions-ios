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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeButtonsState()
        navigationItem.title = "הגדרות"
    }
    
    @IBAction private func generalNotificationsTapped(sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_GENERAL, sender: sender)
    }
    
    @IBAction private func eventsNotificationsTapped(sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_EVENTS, sender: sender)
    }
    
    @IBAction private func cosplayNotificationsTapped(sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_COSPLAY, sender: sender)
    }
    
    @IBAction private func busNotificationsTapped(sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_BUS, sender: sender)
    }
    
    @IBAction func developerOptionsTapped(sender: UISwitch) {
        updateCategoryAndRegister(NotificationHubInfo.CATEGORY_TEST, sender: sender)
    }
    
    @IBAction private func beforeEventNotificationsTapped(sender: UISwitch) {
        NotificationSettings.instance.eventStartingReminder = sender.on
        
        let favoriteEvents = Convention.instance.events.getAll().filter({$0.attending})
        for event in favoriteEvents {
            if sender.on {
                NotificationsSchedualer.scheduleEventAboutToStartNotification(event)
            } else {
                NotificationsSchedualer.removeEventAboutToStartNotification(event)
            }
        }
        
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("Notifications",
            action: sender.on ? "PreferenceSelected" : "PreferenceDeselected",
            label: Convention.name.lowercaseString + "_event_starting_reminder",
            value: NSNumber())
            .build() as [NSObject: AnyObject]);
    }

    @IBAction private func afterEventNotificationsTapped(sender: UISwitch) {
        NotificationSettings.instance.eventFeedbackReminder = sender.on

        let favoriteEvents = Convention.instance.events.getAll().filter({$0.attending})
        for event in favoriteEvents {
            if sender.on {
                NotificationsSchedualer.scheduleEventFeedbackReminderNotification(event)
            } else {
                NotificationsSchedualer.removeEventFeedbackReminderNotification(event)
            }
        }
        
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("Notifications",
            action: sender.on ? "PreferenceSelected" : "PreferenceDeselected",
            label: Convention.name.lowercaseString + "_event_feedback_reminder",
            value: NSNumber())
            .build() as [NSObject: AnyObject]);
    }
    
    private func initializeButtonsState() {
        let registeredCategories = NotificationSettings.instance.categories
        generalCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_GENERAL)
        eventsCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_EVENTS)
        cosplayCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_COSPLAY)
        busCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_BUS)
        developerOptionsButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_TEST)
        
        eventNotificationButton.on = NotificationSettings.instance.eventStartingReminder
        feedbackNotificationButton.on = NotificationSettings.instance.eventFeedbackReminder
        
        if NotificationSettings.instance.developerOptionsEnabled {
            developerOptionsContainerHeightConstraint.constant = 132
            developerOptionsContainer.hidden = false
        } else {
            developerOptionsContainerHeightConstraint.constant = 0
            developerOptionsContainer.hidden = true
        }
    }
    
    private func updateCategoryAndRegister(category: String, sender: UISwitch) {
        let isOn = sender.on
        var currentCategories = NotificationSettings.instance.categories;
        
        if isOn {
            currentCategories.insert(category)
        } else {
            currentCategories.remove(category)
        }
        
        // Register the hub in an async manner not to block the UI
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        hub.registerNativeWithDeviceToken(Convention.deviceToken, tags: currentCategories, completion: {error in
            if error != nil {
                // In case the async operation failed, revert the UI change and show an error indication
                TTGSnackbar(message: "לא ניתן לשנות את ההגדרות. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Short, superView: self.view)
                    .show()
                sender.setOn(!isOn, animated: true)
            } else {
                // after a succesful registration in the hub, persist the new categories
                NotificationSettings.instance.categories = currentCategories
            }
            
            GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("Notifications",
                action: isOn ? "CategoryAdded" : "CategoryRemoved",
                label: category,
                value: error != nil ? 1 : 0)
                .build() as [NSObject: AnyObject]);
        })
    }
}