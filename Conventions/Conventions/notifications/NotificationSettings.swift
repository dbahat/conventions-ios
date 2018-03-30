//
//  UserPreferences.swift
//  Conventions
//
//  Created by David Bahat on 8/9/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationSettings {
    fileprivate static let CATEGORIES = "NotificationCategories"
    fileprivate static let EVENT_FEEDBACK_REMINDER = Convention.name + "_Event_FeedbackReminder"
    fileprivate static let EVENT_STARTING_REMINDER = Convention.name + "_Event_StartingReminder"
    fileprivate static let CONVENTION_FEEDBACK_REMINDER = Convention.name + "_ConventionFeedbackReminder"
    fileprivate static let CONVENTION_FEEDBACK_LAST_CHANCE_REMINDER = Convention.name + "_ConventionFeedbackLastChanceReminder"
    fileprivate static let DEVELOPER_OPTIONS = "DeveloperOptions"
    
    enum Category {
        case general
        case events
        case emergency
        case test
            
        func toString() -> String {
            switch self {
            case .general:
                return Convention.name.lowercased() + "_general"
            case .events:
                return Convention.name.lowercased() + "_events"
            case .emergency:
                return Convention.name.lowercased() + "_emergency"
            case .test:
                return Convention.name.lowercased() + "_test"
            }
        }
    }
        
    private static let DEFAULT_CATEGORIES = [Category.general, Category.events, Category.emergency]
    
    static let instance = NotificationSettings()
    
    let preferences = UserDefaults.standard
    
    var categories: Set<String> {
        get {
            if let storedValue = preferences.stringArray(forKey: NotificationSettings.CATEGORIES) {
                return Set(storedValue)
            }
            return Set(NotificationSettings.DEFAULT_CATEGORIES.map({$0.toString()}))
        }
        set {
            preferences.set(Array(newValue), forKey:NotificationSettings.CATEGORIES)
        }
    }
    
    var eventStartingReminder: Bool {
        get {
            return preferences.bool(forKey: NotificationSettings.EVENT_STARTING_REMINDER)
        }
        set {
            preferences.set(newValue, forKey: NotificationSettings.EVENT_STARTING_REMINDER)
        }
    }
    
    var eventFeedbackReminder : Bool {
        get {
            return preferences.bool(forKey: NotificationSettings.EVENT_FEEDBACK_REMINDER)
        }
        set {
            preferences.set(newValue, forKey: NotificationSettings.EVENT_FEEDBACK_REMINDER)
        }
    }
    
    var conventionFeedbackReminderWasSet : Bool {
        get {
            return preferences.bool(forKey: NotificationSettings.CONVENTION_FEEDBACK_REMINDER)
        }
        set {
            preferences.set(newValue, forKey: NotificationSettings.CONVENTION_FEEDBACK_REMINDER)
        }
    }
    
    var conventionFeedbackLastChanceReminderWasSet : Bool {
        get {
            return preferences.bool(forKey: NotificationSettings.CONVENTION_FEEDBACK_LAST_CHANCE_REMINDER)
        }
        set {
            preferences.set(newValue, forKey: NotificationSettings.CONVENTION_FEEDBACK_LAST_CHANCE_REMINDER)
        }
    }
    
    var developerOptionsEnabled : Bool {
        get {
            return preferences.bool(forKey: NotificationSettings.DEVELOPER_OPTIONS)
        }
        set {
            preferences.set(newValue, forKey: NotificationSettings.DEVELOPER_OPTIONS)
        }
    }
    
    fileprivate init() {
        // by default have both reminders active
        eventStartingReminder = true
        eventFeedbackReminder = true
    }
}
