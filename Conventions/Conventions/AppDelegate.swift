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
    var isActive = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor(hexString: "#7a3d59")
        GMSServices.provideAPIKey("AIzaSyDZLXRjsoElTcja7Hz5WpetzSHFOApMOLI")
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.ForceLeftToRight
        }
        
        // Facebook SDK init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        // Initiate an async refresh to the events and updates when opening the app
        Convention.instance.events.refresh(nil)
        Convention.instance.updates.refresh(nil)
        
        if let options = launchOptions {
            handleNotificationIfNeeded(options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification)
        }
        
        let settings = UIUserNotificationSettings(forTypes: [.Sound , .Alert , .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        NotificationsSchedualer.scheduleConventionFeedback()
        return true;
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        // If the app is active, show the user an alert dialog instead of perfoming the action
        if (isActive) {
            let alert = getAlertForNotification(notification)
            guard let vc = self.window?.rootViewController as? UINavigationController else {return}
            vc.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        handleNotificationIfNeeded(notification)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // When the app isn't active, iOS will show the notification by itself
        if (!isActive) {
            return;
        }
        
        guard let messgae = userInfo["aps"]?["alert"] as? String else {
            return;
        }
        
        let alert = UIAlertController(title: "הודעה התקבלה", message: messgae, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "סגור", style: .Default, handler: nil))
        guard let vc = self.window?.rootViewController as? UINavigationController else {return}
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        isActive = true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        isActive = false
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        // Since we want the launch screen and homeViewController to show in portrait only, and all the 
        // rest of the screens to support landscape, we configure the plist to allow portrait only, and
        // override this definition here.
        return UIInterfaceOrientationMask.All
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME)
        do {
            try hub.registerNativeWithDeviceToken(deviceToken, tags: nil)
        } catch {
            print("error registering to Azure notification hub ", error)
        }
    }
    

    
    private func handleNotificationIfNeeded(notification: UILocalNotification?) {
        handleEventNotificationIfNeeded(notification)
        handleConventionNotificationIfNeeded(notification)
    }
    
    private func handleConventionNotificationIfNeeded(notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let conventionFeedback = userInfo["ConventionFeedback"] as? Bool,
            let vc = self.window?.rootViewController as? UINavigationController,
            let feedbackVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(ConventionFeedbackViewController)) as? ConventionFeedbackViewController
        else {
                return
        }
        
        if conventionFeedback {
            
            vc.pushViewController(feedbackVc, animated: true)
        }
    }
    
    private func handleEventNotificationIfNeeded(notification: UILocalNotification?) {
        guard
            let userInfo = notification?.userInfo,
            let eventId = userInfo["EventId"] as? String,
            let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first,
            let vc = self.window?.rootViewController as? UINavigationController,
            let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(EventViewController)) as? EventViewController
            else {
                return
        }
        
        eventVc.event = event
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
        
        return notification.userInfo?["ConventionFeedback"] as? Bool == true
    }
}

