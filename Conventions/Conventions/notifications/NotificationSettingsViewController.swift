//
//  NotificationSettings.swift
//  Conventions
//
//  Created by David Bahat on 8/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import Firebase

class NotificationSettingsViewController: BaseViewController {
    @IBOutlet private weak var generalCategoryButton: UISwitch!
    @IBOutlet private weak var eventsCategoryButton: UISwitch!
    @IBOutlet private weak var developerOptionsButton: UISwitch!
    
    @IBOutlet private weak var eventNotificationButton: UISwitch!
    @IBOutlet private weak var feedbackNotificationButton: UISwitch!
    
    @IBOutlet private weak var generalTitleLabel: UILabel!
    @IBOutlet private weak var eventsTitleLabel: UILabel!
    @IBOutlet private weak var generalMessageLabel: UILabel!
    @IBOutlet private weak var eventsMessageLabel: UILabel!
    @IBOutlet private weak var beforeEventStartsTitleLabel: UILabel!
    @IBOutlet private weak var beforeEventStartsMessageLabel: UILabel!
    @IBOutlet private weak var eventFeedbackTitleLabel: UILabel!
    @IBOutlet private weak var eventMessageLabel: UILabel!
    @IBOutlet private weak var testTitleLabel: UILabel!
    @IBOutlet private weak var testMessageLabel: UILabel!
    
    @IBOutlet private weak var developerOptionsContainer: UIView!
    @IBOutlet private weak var developerOptionsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var alertsLabel: UILabel!
    @IBOutlet private weak var remindersLabel: UILabel!
    @IBOutlet private weak var contentContainerView: UIView!
    
    private var debugOptionsSwitchTapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeButtonsState()
        navigationItem.title = "הגדרות"
        
        generalCategoryButton.onTintColor = Colors.switchButtonsColor
        eventsCategoryButton.onTintColor = Colors.switchButtonsColor
        developerOptionsButton.onTintColor = Colors.switchButtonsColor
        eventNotificationButton.onTintColor = Colors.switchButtonsColor
        feedbackNotificationButton.onTintColor = Colors.switchButtonsColor
        
        generalTitleLabel.textColor = Colors.textColor
        generalMessageLabel.textColor = Colors.textColor
        eventsTitleLabel.textColor = Colors.textColor
        eventsMessageLabel.textColor = Colors.textColor
        beforeEventStartsTitleLabel.textColor = Colors.textColor
        beforeEventStartsMessageLabel.textColor = Colors.textColor
        eventFeedbackTitleLabel.textColor = Colors.textColor
        eventMessageLabel.textColor = Colors.textColor
        testTitleLabel.textColor = Colors.textColor
        testMessageLabel.textColor = Colors.textColor
        alertsLabel.textColor = Colors.textColor
        remindersLabel.textColor = Colors.textColor
        
        contentContainerView.backgroundColor = Colors.olamot2024_pink50_transparent_80
        contentContainerView.layer.cornerRadius = 4
    }
    
    @IBAction private func generalNotificationsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationSettings.Category.general.toString(), sender: sender)
    }
    
    @IBAction private func eventsNotificationsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationSettings.Category.events.toString(), sender: sender)
    }
    
    @IBAction func developerOptionsTapped(_ sender: UISwitch) {
        updateCategoryAndRegister(NotificationSettings.Category.test.toString(), sender: sender)
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
        
        Analytics.logEvent("Notifications", parameters: [
            "name": sender.isOn ? "PreferenceSelected" : "PreferenceDeselected" as NSObject,
            "label": Convention.name.lowercased() + "_event_starting_reminder" as NSObject
            ])
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
        
        Analytics.logEvent("Notifications", parameters: [
            "name": sender.isOn ? "PreferenceSelected" : "PreferenceDeselected" as NSObject,
            "label": Convention.name.lowercased() + "_event_feedback_reminder" as NSObject
            ])
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
        generalCategoryButton.isOn = registeredCategories.contains(NotificationSettings.Category.general.toString())
        eventsCategoryButton.isOn = registeredCategories.contains(NotificationSettings.Category.events.toString())
        developerOptionsButton.isOn = registeredCategories.contains(NotificationSettings.Category.test.toString())
        
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
            currentCategories.insert(category)
            Messaging.messaging().subscribe(toTopic: category)
        } else {
            currentCategories.remove(category)
            Messaging.messaging().unsubscribe(fromTopic: category)
        }

        NotificationSettings.instance.categories = currentCategories
        Analytics.logEvent("Notifications", parameters: [
            "name": isOn ? "CategoryAdded" : "CategoryRemoved" as NSObject
            ])
    }
}
