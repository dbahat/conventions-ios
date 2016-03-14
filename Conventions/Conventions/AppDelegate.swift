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

    var window: UIWindow?;
    var isActive = true;

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor(hexString: "#402874");
        GMSServices.provideAPIKey("AIzaSyDZLXRjsoElTcja7Hz5WpetzSHFOApMOLI");
        if #available(iOS 9.0, *) {
            // Forcing the app to left-to-right layout, since automatic changing of layout direction only
            // started in iOS9, and we want to support previous iOS versions.
            UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.ForceLeftToRight;
        }
        
        // Facebook SDK init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions);
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        // Initiate an async refresh to the events and updates when opening the app
        Convention.instance.events.refresh(nil);
        Convention.instance.updates.refresh(nil);
        
        if let options = launchOptions {
            handleNotificationIfNeeded(options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification);
        }
        
        return true;
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        // If the app is active, show the user an alert dialog instead of perfoming the action
        if (isActive) {
            // Using hardcoded alert title instead of the notification one, since iOS8 didn't have
            // notification title, and we only support single notification types anyway now.
            let alert = UIAlertController(title: "אירוע עומד להתחיל", message: notification.alertBody, preferredStyle: .Alert);
            alert.addAction(UIAlertAction(title: "פתח אירוע", style: .Default, handler: {action -> Void in
                self.handleNotificationIfNeeded(notification);
            }));
            alert.addAction(UIAlertAction(title: "בטל", style: .Cancel, handler: nil));
            guard let vc = self.window?.rootViewController as? UINavigationController else {return;}
            vc.presentViewController(alert, animated: true, completion: nil);
            return;
        }
        
        handleNotificationIfNeeded(notification)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp();
        isActive = true;
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        isActive = false;
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation);
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        // Since we want the launch screen and homeViewController to show in portrait only, and all the 
        // rest of the screens to support landscape, we configure the plist to allow portrait only, and
        // override this definition here.
        return UIInterfaceOrientationMask.All;
    }
    
    private func handleNotificationIfNeeded(notification: UILocalNotification?) {
        guard let unwrappedNotification = notification else {return;}
        guard let userInfo = unwrappedNotification.userInfo else {return;}
        guard let eventId = userInfo["EventId"] as? String else {return;}
        guard let event = Convention.instance.events.getAll().filter({$0.id == eventId}).first else {return;}
        guard let vc = self.window?.rootViewController as? UINavigationController else {return;}
        guard let eventVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(EventViewController)) as? EventViewController else {return;}
        
        eventVc.event = event;
        vc.pushViewController(eventVc, animated: true);
    }
}

