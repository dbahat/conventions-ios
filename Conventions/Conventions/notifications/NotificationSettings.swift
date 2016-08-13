//
//  UserPreferences.swift
//  Conventions
//
//  Created by David Bahat on 8/9/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationSettings {
    private static let CATEGORIES = "NotificationCategories"
    private static let EVENT_FEEDBACK_REMINDER = Convention.name + "_Event_FeedbackReminder"
    private static let EVENT_STARTING_REMINDER = Convention.name + "_Event_StartingReminder"
    private static let CONVENTION_FEEDBACK_REMINDER = "ConventionFeedbackReminder"
    private static let DEVELOPER_OPTIONS = "DeveloperOptions"
    
    static let instance = NotificationSettings()
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    var categories: Set<String> {
        get {
            if let storedValue = preferences.stringArrayForKey(NotificationSettings.CATEGORIES) {
                return Set(storedValue)
            }
            return Set(NotificationHubInfo.DEFAULT_CATEGORIES)
        }
        set {
            preferences.setObject(Array(newValue), forKey:NotificationSettings.CATEGORIES)
        }
    }
    
    var eventStartingReminder: Bool {
        get {
            return preferences.boolForKey(NotificationSettings.EVENT_STARTING_REMINDER)
        }
        set {
            preferences.setBool(newValue, forKey: NotificationSettings.EVENT_STARTING_REMINDER)
        }
    }
    
    var eventFeedbackReminder : Bool {
        get {
            return preferences.boolForKey(NotificationSettings.EVENT_FEEDBACK_REMINDER)
        }
        set {
            preferences.setBool(newValue, forKey: NotificationSettings.EVENT_FEEDBACK_REMINDER)
        }
    }
    
    var conventionFeedbackReminderWasSet : Bool {
        get {
            return preferences.boolForKey(NotificationSettings.CONVENTION_FEEDBACK_REMINDER)
        }
        set {
            preferences.setBool(newValue, forKey: NotificationSettings.CONVENTION_FEEDBACK_REMINDER)
        }
    }
    
    var developerOptionsEnabled : Bool {
        get {
            return preferences.boolForKey(NotificationSettings.DEVELOPER_OPTIONS)
        }
        set {
            preferences.setBool(newValue, forKey: NotificationSettings.DEVELOPER_OPTIONS)
        }
    }
    
    private init() {
        // by default have both reminders active
        eventStartingReminder = true
        eventFeedbackReminder = true
    }
}