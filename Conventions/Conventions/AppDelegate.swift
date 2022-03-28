//
//  AppDelegate.swift
//  Conventions
//
//  Created by David Bahat on 1/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    // Current app state (forground or background). Needed to know how to handle incoming notifications.
    var isActive = true
    
    // The message we got in a remote notification. Needed in case we get push notification while in background
    private var remoteNotificationMessage: String = ""
    private var remoteNotificationCategory: String = ""
    private var remoteNotificationId: String = ""
    
    private var webViewCache: StaticContentWebView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UITabBar.appearance().unselectedItemTintColor = Colors.tabBarUnselectedTabColor
        UITabBar.appearance().tintColor = Colors.tabBarSelectedTabColor
        GMSServices.provideAPIKey("AIzaSyBDa-mGOL6WFuXsHsu_0XL5RkuEgqho8a0")
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        }

        // Initiate an async refresh to the updates when opening the app.
        Convention.instance.updates.refresh(nil)
        Convention.instance.events.refresh(nil)
        
        loadWebViewCache()
        
        if let options = launchOptions {
            // In case we were launched due to user clicking a notification, handle the notification
            // now (e.g. navigate to a specific page, show the notification in a larger popup...).
            // Dispatching the task to the message queue so the UI will finish it's init first.
            if let localNotification = options[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
                DispatchQueue.main.async {
                    self.handleNotificationIfNeeded(localNotification)
                }
            }
            
            if let remoteNotification = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                DispatchQueue.main.async {
                    // In case we got opened from a remove notification, also navigate to the updates page
                    self.showPushNotificationPopup(remoteNotification, shouldNavigateToUpdates: true)
                }
            }
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        for category in NotificationSettings.instance.categories {
            Messaging.messaging().subscribe(toTopic: category)
        }
        
        return true;
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        // If the app is active, show the user an alert dialog instead of perfoming the action
        if isActive {
            let alert = getAlertForNotification(notification)
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            vc.present(alert, animated: true, completion: nil)
            return;
        }
        
        handleNotificationIfNeeded(notification)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        showPushNotificationPopup(userInfo, shouldNavigateToUpdates: false /* so we won't interupt the user */)
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        showPushNotificationPopup(userInfo, shouldNavigateToUpdates: false)
        completionHandler()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        isActive = true
        
        // Clear the app icon badge, in case it was set by a remote notification
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // In case we got push notification while in background, show it to the user in a larger dialog
        // since some notifications may be too long for the iOS default notification area
        if remoteNotificationMessage != "" {
            showNotificationPopup(remoteNotificationMessage, category: remoteNotificationCategory)
            remoteNotificationMessage = ""
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        isActive = false
    }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        // Scheduling the feedback reminder here, since we can only schedule notifications after the 
        // notifications settings were registered (and the user gave his concent)
        NotificationsSchedualer.scheduleConventionFeedbackIfNeeded()
        NotificationsSchedualer.scheduleConventionFeedbackLastChanceIfNeeded()
    }
    
    private func showPushNotificationPopup(_ userInfo: [AnyHashable: Any], shouldNavigateToUpdates: Bool) {
        guard let rawMessage = userInfo["aps"] as? [String: Any],
            let alert = rawMessage["alert"] as? [String: Any],
            let message = alert["body"] as? String else {
            return;
        }
        let category = userInfo["topic"] as? String ?? ""
        let id = userInfo["id"] as? String ?? ""
        
        // When the app isn't active we want to allow iOS to show the notification, and only present it
        // to the user if he clicked the notification
        if !isActive {
            remoteNotificationMessage = message
            remoteNotificationCategory = category
            remoteNotificationId = id
            return;
        }
        
        if shouldNavigateToUpdates {
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            if let updatesVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: UpdatesViewController.self)) as? UpdatesViewController {
                vc.pushViewController(updatesVc, animated: true)
            }
        }
        
        showNotificationPopup(message, category: category)
    }
    
    private func showNotificationPopup(_ message: String, category: String) {
        
        let alert = UIAlertController(title: categoryIdToName(category), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "שנה הגדרות", style: .default, handler: {action in
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            if let settingsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: NotificationSettingsViewController.self)) as? NotificationSettingsViewController {
                vc.pushViewController(settingsVc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "סגור", style: .default, handler: nil))
        guard let vc = self.window?.rootViewController as? UINavigationController else {return}
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func handleNotificationIfNeeded(_ notification: UILocalNotification?) {
        handleEventAboutToStartNotificationIfNeeded(notification)
        handleEventFeedbackReminderNotificationIfNeeded(notification)
        handleConventionNotificationIfNeeded(notification)
    }
    
    private func handleConventionNotificationIfNeeded(_ notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let vc = self.window?.rootViewController as? UINavigationController,
            let feedbackVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ConventionFeedbackViewController.self)) as? ConventionFeedbackViewController
        else {
                return
        }
        
        if userInfo[NotificationsSchedualer.CONVENTION_FEEDBACK_INFO] as? Bool != nil {
            vc.pushViewController(feedbackVc, animated: true)
        } else if userInfo[NotificationsSchedualer.CONVENTION_FEEDBACK_LAST_CHANCE_INFO] as? Bool != nil {
            vc.pushViewController(feedbackVc, animated: true)
        }
    }
    
    private func handleEventAboutToStartNotificationIfNeeded(_ notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let eventId = userInfo[NotificationsSchedualer.EVENT_ABOUT_TO_START_INFO] as? String,
            let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first,
            let vc = self.window?.rootViewController as? UINavigationController,
            let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? EventViewController
            else {
                return
        }
        
        eventVc.event = event
        vc.pushViewController(eventVc, animated: true)
    }
    
    private func handleEventFeedbackReminderNotificationIfNeeded(_ notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let eventId = userInfo[NotificationsSchedualer.EVENT_FEEDBACK_REMINDER_INFO] as? String,
            let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first,
            let vc = self.window?.rootViewController as? UINavigationController,
            let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? EventViewController
            else {
                return
        }
        
        eventVc.event = event
        eventVc.feedbackViewOpen = true
        vc.pushViewController(eventVc, animated: true)
    }
    
    private func getAlertForNotification(_ notification: UILocalNotification) -> UIAlertController {
        // Using hardcoded alert title instead of the notification one, since iOS8 didn't have
        // notification title
        if isConventionFeedbackNotification(notification) {
            let alert = UIAlertController(title: "עזור לנו להשתפר", message: notification.alertBody, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "מלא פידבק לספטיבל", style: .default, handler: {action -> Void in
                self.handleNotificationIfNeeded(notification)
            }));
            alert.addAction(UIAlertAction(title: "בטל", style: .cancel, handler: nil))
            return alert
        } else {
            let alert = UIAlertController(title: "אירוע עומד להתחיל", message: notification.alertBody, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "פתח אירוע", style: .default, handler: {action -> Void in
                self.handleNotificationIfNeeded(notification)
            }));
            alert.addAction(UIAlertAction(title: "בטל", style: .cancel, handler: nil))
            return alert
        }
    }
    
    private func isConventionFeedbackNotification(_ notification: UILocalNotification) -> Bool {
        
        return notification.userInfo?[NotificationsSchedualer.CONVENTION_FEEDBACK_INFO] as? Bool == true
    }
    
    private func categoryIdToName(_ category: String) -> String {
        if category == NotificationSettings.Category.test.toString() {
            return "בדיקות"
        }
        if category == NotificationSettings.Category.events.toString() {
            return "אירועים"
        }
        
        return "התראה"
    }
    
    // Needed since initial loading of a webView is 'heavy', and if done in a lazy manner causes the user to see an empty webview for a few seconds.
    // This happens only once, regardless of the webView instance created.
    // To resolve this, create a dummy instance which isn't used anywhere, and will handle the initial loading time (at the cost of extra memory).
    // Future refactoring can dismiss this webView once loaded to save memory.
    private func loadWebViewCache() {
        if
            let resourcePath = Bundle.main.resourcePath,
            let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") {
            
            webViewCache = StaticContentWebView(frame: CGRect.zero)
            webViewCache?.setContent(aboutContent)
        }
    }
}

