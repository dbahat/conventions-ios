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
        
        let registeredCategories = Convention.instance.notificationCategories
        generalCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_GENERAL)
        eventsCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_EVENTS)
        cosplayCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_COSPLAY)
        busCategoryButton.on = registeredCategories.contains(NotificationHubInfo.CATEGORY_BUS)
        
        eventNotificationButton.on = NSUserDefaults.standardUserDefaults().boolForKey("EventReminderNotification")
        feedbackNotificationButton.on = NSUserDefaults.standardUserDefaults().boolForKey("FeedbackReminderNotification")
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
        for event in Convention.instance.events.getAll() {
            NotificationsSchedualer.removeEventNotifications(event)
        }
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "EventReminderNotification")
    }
    
    @IBAction private func afterEventNotificationsTapped(sender: UISwitch) {
        for event in Convention.instance.events.getAll() {
            NotificationsSchedualer.removeEventNotifications(event)
        }
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "FeedbackReminderNotification")
    }
    
    private func updateCategory(category: String, isOn: Bool) {
        if isOn {
            Convention.instance.notificationCategories.insert(category)
        } else {
            Convention.instance.notificationCategories.remove(category)
        }
    
        NSUserDefaults.standardUserDefaults().setObject(Array(Convention.instance.notificationCategories), forKey: NotificationHubInfo.CATEGORIES_NSUSERDEFAULTS_KEY)
    }
    
    private func register() {
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        do {
            try hub.registerNativeWithDeviceToken(Convention.deviceToken, tags: Convention.instance.notificationCategories)
        } catch {
            print("error registering to Azure notification hub ", error)
        }
    }
}