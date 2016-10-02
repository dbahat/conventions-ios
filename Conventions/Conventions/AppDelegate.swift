//
//  AppDelegate.swift
//  Conventions
//
//  Created by David Bahat on 1/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Current app state (forground or background). Needed to know how to handle incoming notifications.
    var isActive = true
    
    // The message we got in a remote notification. Needed in case we get push notification while in background
    private var remoteNotificationMessage: String = ""
    private var remoteNotificationCategory: String = ""

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = Colors.colorAccent
        GMSServices.provideAPIKey("AIzaSyBDa-mGOL6WFuXsHsu_0XL5RkuEgqho8a0")
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.ForceLeftToRight
        }
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        // Initiate an async refresh to the updates when opening the app. Events will be refeshed
        // anyways since the programme is the initial screen.
        Convention.instance.updates.refresh(nil)
        
        if let options = launchOptions {
            // In case we were launched due to user clicking a notification, handle the notification
            // now (e.g. navigate to a specific page, show the notification in a larger popup...).
            // Dispatching the task to the message queue so the UI will finish it's init first.
            if let localNotification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                dispatch_async(dispatch_get_main_queue()) {
                    self.handleNotificationIfNeeded(localNotification)
                }
            }
            
            if let remoteNotification = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
                dispatch_async(dispatch_get_main_queue()) {
                    self.application(application, didReceiveRemoteNotification: remoteNotification)
                }
            }
        }
        
        let settings = UIUserNotificationSettings(forTypes: [.Sound , .Alert , .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true;
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        // If the app is active, show the user an alert dialog instead of perfoming the action
        if isActive {
            let alert = getAlertForNotification(notification)
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            vc.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        handleNotificationIfNeeded(notification)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        guard let message = userInfo["aps"]?["alert"] as? String else {
            return;
        }
        let category = userInfo["category"] as? String ?? ""
        
        // When the app isn't active we want to allow iOS to show the notification, and only present it
        // to the user if he clicked the notification
        if !isActive {
            remoteNotificationMessage = message
            remoteNotificationCategory = category
            return;
        }
        
        showNotificationPopup(message, category: category)
    }
    
    private func showNotificationPopup(message: String, category: String) {
        
        let alert = UIAlertController(title: categoryIdToName(category), message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "שנה הגדרות", style: .Default, handler: {action in
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            if let settingsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(NotificationSettingsViewController)) as? NotificationSettingsViewController {
                vc.pushViewController(settingsVc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "סגור", style: .Default, handler: nil))
        guard let vc = self.window?.rootViewController as? UINavigationController else {return}
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        isActive = true
        
        // In case we got push notification while in background, show it to the user in a larger dialog
        // since some notifications may be too long for the iOS default notification area
        if remoteNotificationMessage != "" {
            showNotificationPopup(remoteNotificationMessage, category: remoteNotificationCategory)
            remoteNotificationMessage = ""
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        isActive = false
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        // Since we want the launch screen and homeViewController to show in portrait only, and all the 
        // rest of the screens to support landscape, we configure the plist to allow portrait only, and
        // override this definition here.
        return UIInterfaceOrientationMask.All
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        // Scheduling the feedback reminder here, since we can only schedule notifications after the 
        // notifications settings were registered (and the user gave his concent)
        NotificationsSchedualer.scheduleConventionFeedbackIfNeeded()
        NotificationsSchedualer.scheduleConventionFeedbackLastChanceIfNeeded()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Convention.deviceToken = deviceToken
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        do {
            try hub.registerNativeWithDeviceToken(deviceToken, tags: NotificationSettings.instance.categories)
        } catch {
            print("error registering to Azure notification hub ", error)
        }
    }
    
    private func handleNotificationIfNeeded(notification: UILocalNotification?) {
        handleEventAboutToStartNotificationIfNeeded(notification)
        handleEventFeedbackReminderNotificationIfNeeded(notification)
        handleConventionNotificationIfNeeded(notification)
    }
    
    private func handleConventionNotificationIfNeeded(notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let vc = self.window?.rootViewController as? UINavigationController,
            let feedbackVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(ConventionFeedbackViewController)) as? ConventionFeedbackViewController
        else {
                return
        }
        
        if userInfo[NotificationsSchedualer.CONVENTION_FEEDBACK_INFO] as? Bool != nil {
            vc.pushViewController(feedbackVc, animated: true)
        } else if userInfo[NotificationsSchedualer.CONVENTION_FEEDBACK_LAST_CHANCE_INFO] as? Bool != nil {
            vc.pushViewController(feedbackVc, animated: true)
        }
    }
    
    private func handleEventAboutToStartNotificationIfNeeded(notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let eventId = userInfo[NotificationsSchedualer.EVENT_ABOUT_TO_START_INFO] as? String,
            let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first,
            let vc = self.window?.rootViewController as? UINavigationController,
            let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(EventViewController)) as? EventViewController
            else {
                return
        }
        
        eventVc.event = event
        vc.pushViewController(eventVc, animated: true)
    }
    
    private func handleEventFeedbackReminderNotificationIfNeeded(notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let eventId = userInfo[NotificationsSchedualer.EVENT_FEEDBACK_REMINDER_INFO] as? String,
            let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first,
            let vc = self.window?.rootViewController as? UINavigationController,
            let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(EventViewController)) as? EventViewController
            else {
                return
        }
        
        eventVc.event = event
        eventVc.feedbackViewOpen = true
        vc.pushViewController(eventVc, animated: true)
    }
    
    private func getAlertForNotification(notification: UILocalNotification) -> UIAlertController {
        // Using hardcoded alert title instead of the notification one, since iOS8 didn't have
        // notification title
        if isConventionFeedbackNotification(notification) {
            let alert = UIAlertController(title: "עזור לנו להשתפר", message: notification.alertBody, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "מלא פידבק לכנס", style: .Default, handler: {action -> Void in
                self.handleNotificationIfNeeded(notification)
            }));
            alert.addAction(UIAlertAction(title: "בטל", style: .Cancel, handler: nil))
            return alert
        } else {
            let alert = UIAlertController(title: "אירוע עומד להתחיל", message: notification.alertBody, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "פתח אירוע", style: .Default, handler: {action -> Void in
                self.handleNotificationIfNeeded(notification)
            }));
            alert.addAction(UIAlertAction(title: "בטל", style: .Cancel, handler: nil))
            return alert
        }
    }
    
    private func isConventionFeedbackNotification(notification: UILocalNotification) -> Bool {
        
        return notification.userInfo?[NotificationsSchedualer.CONVENTION_FEEDBACK_INFO] as? Bool == true
    }
    
    private func categoryIdToName(category: String) -> String {
        if category == NotificationHubInfo.CATEGORY_TEST {
            return "בדיקות"
        }
        if category == NotificationHubInfo.CATEGORY_EVENTS {
            return "אירועים"
        }
        
        return "התראה"
    }
}

