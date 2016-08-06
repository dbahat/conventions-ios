//
//  NotificationsSchedualer.swift
//  Conventions
//
//  Created by David Bahat on 8/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationsSchedualer {
    
    private static let wasConventionScheduledKey = "wasConventionFeedbackNotificationScheduled"
    private static let conventionUserInfo = "ConventionFeedback"
    private static let eventUserInfo = "EventId"
    
    static func scheduleConventionFeedback() {
        
        if NSUserDefaults.standardUserDefaults().boolForKey(wasConventionScheduledKey)
            || Convention.instance.feedback.conventionInputs.isSent
            || Convention.instance.isFeedbackSendingTimeOver() {
            return;
        }
        
        let notification = UILocalNotification()
        notification.fireDate = Convention.date.addDays(1).addHours(10)
        notification.timeZone = NSTimeZone.systemTimeZone()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "עזור לנו להשתפר"
        }
        notification.alertBody = String(format: "%@ הסתיים, ואנחנו רוצים לשמוע את דעתך", arguments: [Convention.displayName]);
        notification.alertAction = "מלא פידבק לכנס"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [conventionUserInfo: true];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: wasConventionScheduledKey)
    }
    
    static func removeConventionFeedback() {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let conventionFeedback = userInfo[conventionUserInfo] as? Bool
                else {
                    continue;
            }
            
            if conventionFeedback {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
    
    static func scheduleEventNotifications(event: ConventionEvent) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings);
        
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None) {return;}
        
        // Don't schdule a notification in the past
        if (event.startTime.addMinutes(-5).timeIntervalSince1970 < NSDate().timeIntervalSince1970) {return;}
        
        let notification = UILocalNotification();
        notification.fireDate = event.startTime.addMinutes(-5);
        notification.timeZone = NSTimeZone.systemTimeZone();
        if #available(iOS 8.2, *) {
            notification.alertTitle = "אירוע עומד להתחיל"
        }
        notification.alertBody = String(format: "האירוע %@ עומד להתחיל ב%@", arguments: [event.title, event.hall.name]);
        notification.alertAction = "לפתיחת האירוע"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [eventUserInfo: event.id];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func removeEventNotifications(event: ConventionEvent) {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard
                let userInfo = notification.userInfo,
                let eventId = userInfo[eventUserInfo] as? String
                else {
                    continue;
            }
            
            if eventId == event.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
}