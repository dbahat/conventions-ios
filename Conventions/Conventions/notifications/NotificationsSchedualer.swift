//
//  NotificationsSchedualer.swift
//  Conventions
//
//  Created by David Bahat on 8/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationsSchedualer {
    
    static let CONVENTION_FEEDBACK_INFO = "ConventionFeedback"
    static let CONVENTION_FEEDBACK_LAST_CHANCE_INFO = "ConventionFeedbackLastChance"
    static let EVENT_ABOUT_TO_START_INFO = "EventAboutToStart"
    static let EVENT_FEEDBACK_REMINDER_INFO = "EventFeedbackReminder"
    
    static func scheduleConventionFeedbackIfNeeded() {
        
        if (UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) {return}
        
        if NotificationSettings.instance.conventionFeedbackReminderWasSet
            || Convention.instance.feedback.conventionInputs.isSent
            || Convention.instance.isFeedbackSendingTimeOver() {
            return;
        }
        
        let notification = UILocalNotification()
        notification.fireDate = Convention.endDate.addHours(22)
        notification.timeZone = Date.timeZone
        if #available(iOS 8.2, *) {
            notification.alertTitle = "עזור לנו להשתפר"
        }
        notification.alertBody = String(format: "%@ הסתיים, ואנחנו רוצים לשמוע את דעתך", arguments: [Convention.displayName]);
        notification.alertAction = "מלא פידבק על הפסטיבל"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [CONVENTION_FEEDBACK_INFO: true];
        UIApplication.shared.scheduleLocalNotification(notification)
        
        NotificationSettings.instance.conventionFeedbackReminderWasSet = true
    }
    
    static func scheduleConventionFeedbackLastChanceIfNeeded() {
        
        if (UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) {return}
        
        if NotificationSettings.instance.conventionFeedbackLastChanceReminderWasSet
            || Convention.instance.feedback.conventionInputs.isSent
            || Convention.instance.isFeedbackSendingTimeOver() {
            return;
        }
        
        let notification = UILocalNotification()
        notification.fireDate = Convention.endDate.addDays(4)
        notification.timeZone = Date.timeZone
        if #available(iOS 8.2, *) {
            notification.alertTitle = "הזדמנות אחרונה להשפיע"
        }
        notification.alertBody = String(format: "נהנתם ב%@? נשארו רק עוד 3 ימים לשליחת פידבק!", arguments: [Convention.displayName]);
        notification.alertAction = "מלא פידבק על הפסטיבל"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [CONVENTION_FEEDBACK_LAST_CHANCE_INFO: true];
        UIApplication.shared.scheduleLocalNotification(notification)
        
        NotificationSettings.instance.conventionFeedbackLastChanceReminderWasSet = true
    }
    
    static func removeConventionFeedback() {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let conventionFeedback = userInfo[CONVENTION_FEEDBACK_INFO] as? Bool
                else {
                    continue;
            }
            
            if conventionFeedback {
                UIApplication.shared.cancelLocalNotification(notification);
            }
        }
    }
    
    static func removeConventionFeedbackLastChance() {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let conventionFeedback = userInfo[CONVENTION_FEEDBACK_LAST_CHANCE_INFO] as? Bool
                else {
                    continue;
            }
            
            if conventionFeedback {
                UIApplication.shared.cancelLocalNotification(notification);
            }
        }
    }
    
    static func scheduleEventAboutToStartNotification(_ event: ConventionEvent) {
        
        if (UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) {return}
        
        // In case the user manually disabled event reminder notifications don't schedule anything
        if !NotificationSettings.instance.eventStartingReminder {
            return
        }
        
        // Don't schdule a notification in the past
        if (event.startTime.addMinutes(-5).timeIntervalSince1970 < Date.now().timeIntervalSince1970) {return;}
        
        let notification = UILocalNotification()
        notification.fireDate = event.startTime.addMinutes(-5)
        notification.timeZone = Date.timeZone
        if #available(iOS 8.2, *) {
            notification.alertTitle = "אירוע עומד להתחיל"
        }
        notification.alertBody = String(format: "האירוע %@ עומד להתחיל ב%@", arguments: [event.title, event.hall.name])
        notification.alertAction = "לפתיחת האירוע"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [EVENT_ABOUT_TO_START_INFO: event.id]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    static func removeEventAboutToStartNotification(_ event: ConventionEvent) {
        NotificationsSchedualer.removeEventNotification(event, identifier: EVENT_ABOUT_TO_START_INFO)
    }
    
    static func scheduleEventFeedbackReminderNotification(_ event: ConventionEvent) {
        
        if (UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) {return}
        
        // In case the user manually disabled event reminder notifications don't schedule anything
        if !NotificationSettings.instance.eventFeedbackReminder {
            return
        }
        
        // Don't schdule a notification in the past
        if (event.endTime.timeIntervalSince1970 < Date.now().timeIntervalSince1970) {return;}
        
        // event about to start notification
        let notification = UILocalNotification()
        notification.fireDate = event.endTime.addMinutes(5)
        notification.timeZone = Date.timeZone
        if #available(iOS 8.2, *) {
            notification.alertTitle = "עזור לנו להשתפר"
        }
        notification.alertBody = String(format: "נהנית באירוע %@? שלח פידבק למארגני האירוע", arguments: [event.title, event.hall.name])
        notification.alertAction = "מלא פידבק"
        notification.userInfo = [EVENT_FEEDBACK_REMINDER_INFO: event.id]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    static func removeEventFeedbackReminderNotification(_ event: ConventionEvent) {
        NotificationsSchedualer.removeEventNotification(event, identifier: EVENT_FEEDBACK_REMINDER_INFO)
    }
    
    fileprivate static func removeEventNotification(_ event: ConventionEvent, identifier: String) {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let eventId = userInfo[identifier] as? String
                else {
                    continue;
            }
            
            if eventId == event.id {
                UIApplication.shared.cancelLocalNotification(notification);
            }
        }
    }
}
