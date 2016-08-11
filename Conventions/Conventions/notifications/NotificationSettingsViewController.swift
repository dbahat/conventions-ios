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
    
    @IBOutlet private weak var developerOptionsTitle: UILabel!
    @IBOutlet private weak var developerOptionsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeButtonsState()
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
        NotificationSettings.instance.eventReminder = sender.on
        
        let favoriteEvents = Convention.instance.events.getAll().filter({$0.attending})
        for event in favoriteEvents {
            if sender.on {
                NotificationsSchedualer.scheduleEventAboutToStartNotification(event)
            } else {
                NotificationsSchedualer.removeEventAboutToStartNotification(event)
            }
        }
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
    }
    
    private func initializeButtonsState() {
        let registeredCategories = NotificationSettings.instance.categories
        generalCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_GENERAL)
        eventsCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_EVENTS)
        cosplayCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_COSPLAY)
        busCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_BUS)
        
        eventNotificationButton.on = NotificationSettings.instance.eventReminder
        feedbackNotificationButton.on = NotificationSettings.instance.eventFeedbackReminder
        
        if NotificationSettings.instance.developerOptionsEnabled {
            developerOptionsTitle.hidden = false
            developerOptionsContainer.hidden = false
            developerOptionsButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_TEST)
        }
    }
    
    private func updateCategoryAndRegister(category: String, sender: UISwitch) {
        let isOn = sender.on

        // Register the hub in an async manner not to block the UI
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        hub.registerNativeWithDeviceToken(Convention.deviceToken, tags: NotificationSettings.instance.categories, completion: {error in
            if error != nil {
                // In case the async operation failed, revert the UI change and show an error indication
                TTGSnackbar(message: "לא ניתן לשנות את ההגדרות. נסה שנית מאוחר יותר", duration: TTGSnackbarDuration.Short, superView: self.view)
                    .show()
                sender.setOn(!isOn, animated: true)
            } else {
                // after a succesful registration in the hub, persist the new categories
                if isOn {
                    NotificationSettings.instance.categories.insert(category)
                } else {
                    NotificationSettings.instance.categories.remove(category)
                }
            }
        })
    }
}