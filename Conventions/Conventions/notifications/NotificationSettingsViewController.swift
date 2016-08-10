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
    
    @IBOutlet private weak var eventNotificationButton: UISwitch!
    @IBOutlet private weak var feedbackNotificationButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registeredCategories = NotificationSettings.instance.categories
        generalCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_GENERAL)
        eventsCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_EVENTS)
        cosplayCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_COSPLAY)
        busCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_BUS)
        
        eventNotificationButton.on = NotificationSettings.instance.eventReminder
        feedbackNotificationButton.on = NotificationSettings.instance.eventFeedbackReminder
    }
    
    @IBAction private func generalNotificationsTapped(sender: UISwitch) {
        updateCategory(NotificationHubInfo.CATEGORY_GENERAL, isOn: sender.on)
        register()
    }
    
    @IBAction private func eventsNotificationsTapped(sender: UISwitch) {
        updateCategory(NotificationHubInfo.CATEGORY_EVENTS, isOn: sender.on)
        register()
    }
    
    @IBAction private func cosplayNotificationsTapped(sender: UISwitch) {
        updateCategory(NotificationHubInfo.CATEGORY_COSPLAY, isOn: sender.on)
        register()
    }
    
    @IBAction private func busNotificationsTapped(sender: UISwitch) {
        updateCategory(NotificationHubInfo.CATEGORY_BUS, isOn: sender.on)
        register()
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
    
    private func updateCategory(category: String, isOn: Bool) {
        if isOn {
            NotificationSettings.instance.categories.insert(category)
        } else {
            NotificationSettings.instance.categories.remove(category)
        }
    }
    
    private func register() {
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        do {
            try hub.registerNativeWithDeviceToken(Convention.deviceToken, tags: NotificationSettings.instance.categories)
        } catch {
            print("error registering to Azure notification hub ", error)
        }
    }
}