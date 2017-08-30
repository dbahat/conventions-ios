//
//  NotificationHubInfo.swift
//  Conventions
//
//  Created by David Bahat on 6/9/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationHubInfo {
    static let NAME = "icon2017"
    static let CONNECTIONSTRING = "Endpoint=sb://sff-conventions.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=iQiBIOy0yZJJIuUIpOtpzmd6O5AQQdmZGtoN3J4TXH0="
    
    static let CATEGORY_GENERAL = "icon2017_general"
    static let CATEGORY_EVENTS = "icon2017_events"
    static let CATEGORY_EMERGENCY = "icon2017_emergency"
    static let CATEGORY_TEST = "icon2017_test"
    
    static let DEFAULT_CATEGORIES = [CATEGORY_GENERAL, CATEGORY_EVENTS, CATEGORY_EMERGENCY]
}
