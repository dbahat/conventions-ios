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
    private static let EVENT_REMINDER = "EventReminder"
    private static let EVENT_FEEDBACK_REMINDER = "EventFeedbackReminder"
    private static let CONVENTION_FEEDBACK_REMINDER = "ConventionFeedbackReminder"
    
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
    
    var eventReminder: Bool {
        get {
            return preferences.boolForKey(NotificationSettings.EVENT_REMINDER)
        }
        set {
            preferences.setBool(newValue, forKey: NotificationSettings.EVENT_REMINDER)
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
    
    private init() {
        // by default have both reminders active
        eventReminder = true
        eventFeedbackReminder = true
    }
}