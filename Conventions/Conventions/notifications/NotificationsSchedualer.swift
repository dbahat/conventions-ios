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
    static let EVENT_ABOUT_TO_START_INFO = "EventAboutToStart"
    static let EVENT_FEEDBACK_REMINDER_INFO = "EventFeedbackReminder"
    
    static func scheduleConventionFeedbackIfNeeded() {
        
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None) {return}
        
        if NotificationSettings.instance.conventionFeedbackReminderWasSet
            || Convention.instance.feedback.conventionInputs.isSent
            || Convention.instance.isFeedbackSendingTimeOver() {
            return;
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate.from(year: 2016, month: 8, day: 25).addDays(1).addHours(10)
        notification.timeZone = NSTimeZone.systemTimeZone()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "עזור לנו להשתפר"
        }
        notification.alertBody = String(format: "%@ הסתיים, ואנחנו רוצים לשמוע את דעתך", arguments: [Convention.displayName]);
        notification.alertAction = "מלא פידבק על הפסטיבל"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [CONVENTION_FEEDBACK_INFO: true];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        NotificationSettings.instance.conventionFeedbackReminderWasSet = true
    }
    
    static func removeConventionFeedback() {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let conventionFeedback = userInfo[CONVENTION_FEEDBACK_INFO] as? Bool
                else {
                    continue;
            }
            
            if conventionFeedback {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
    
    static func scheduleEventAboutToStartNotification(event: ConventionEvent) {
        
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None) {return}
        
        // In case the user manually disabled event reminder notifications don't schedule anything
        if !NotificationSettings.instance.eventStartingReminder {
            return
        }
        
        // Don't schdule a notification in the past
        if (event.startTime.addMinutes(-5).timeIntervalSince1970 < NSDate().timeIntervalSince1970) {return;}
        
        let notification = UILocalNotification()
        notification.fireDate = event.startTime.addMinutes(-5)
        notification.timeZone = NSTimeZone.systemTimeZone()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "אירוע עומד להתחיל"
        }
        notification.alertBody = String(format: "האירוע %@ עומד להתחיל ב%@", arguments: [event.title, event.hall.name])
        notification.alertAction = "לפתיחת האירוע"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [EVENT_ABOUT_TO_START_INFO: event.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func removeEventAboutToStartNotification(event: ConventionEvent) {
        NotificationsSchedualer.removeEventNotification(event, identifier: EVENT_ABOUT_TO_START_INFO)
    }
    
    static func scheduleEventFeedbackReminderNotification(event: ConventionEvent) {
        
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None) {return}
        
        // In case the user manually disabled event reminder notifications don't schedule anything
        if !NotificationSettings.instance.eventFeedbackReminder {
            return
        }
        
        // Don't schdule a notification in the past
        if (event.endTime.timeIntervalSince1970 < NSDate().timeIntervalSince1970) {return;}
        
        // event about to start notification
        let notification = UILocalNotification()
        notification.fireDate = event.endTime.addMinutes(5)
        notification.timeZone = NSTimeZone.systemTimeZone()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "עזור לנו להשתפר"
        }
        notification.alertBody = String(format: "נהנית באירוע %@? שלח פידבק למארגני האירוע", arguments: [event.title, event.hall.name])
        notification.alertAction = "מלא פידבק"
        notification.userInfo = [EVENT_FEEDBACK_REMINDER_INFO: event.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func removeEventFeedbackReminderNotification(event: ConventionEvent) {
        NotificationsSchedualer.removeEventNotification(event, identifier: EVENT_FEEDBACK_REMINDER_INFO)
    }
    
    private static func removeEventNotification(event: ConventionEvent, identifier: String) {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let eventId = userInfo[identifier] as? String
                else {
                    continue;
            }
            
            if eventId == event.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
}
