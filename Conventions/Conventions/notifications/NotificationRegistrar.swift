//
//  NotificationRegistrar.swift
//  Conventions
//
//  Created by David Bahat on 29/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class NotificationRegistrar {
    private let settings: NotificationSettings
    private let events: Events
    
    var deviceToken: Data?
    
    init(settings: NotificationSettings, events: Events) {
        self.settings = settings
        self.events = events
    }
    
    func register(_ callback: ((Bool) -> Void)?) {
        guard let token = deviceToken else {
            print("unable to register for push notifications - missing device token")
            callback?(false)
            return
        }
        
        var tags = NotificationSettings.instance.categories
        if tags.contains(NotificationHubInfo.CATEGORY_EVENTS) {
            tags = tags.union(events.getAll()
                .filter({$0.attending})
                .map({Convention.name.lowercased() + "_event_" + $0.serverId.description}))
        }
        
        print("registering to notifications for tags: " + tags.description)
        
        guard let hub = SBNotificationHub(connectionString: NotificationHubInfo.CONNECTIONSTRING, notificationHubPath: NotificationHubInfo.NAME) else {
            print("unable to register for push notifications - bad connection string")
            callback?(false)
            return
        }
        hub.registerNative(withDeviceToken: token, tags: tags, completion: {error in
            callback?(error == nil)
        })
    }
}
