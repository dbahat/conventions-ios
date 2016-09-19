//
//  NotificationHubInfo.swift
//  Conventions
//
//  Created by David Bahat on 6/9/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class NotificationHubInfo {
    static let NAME = "conventions"
    static let CONNECTIONSTRING = "Endpoint=sb://sff-conventions.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=dCrJSDNwpotcGHGwLo4EKObl8cAtVVagaUO3CtPuMSo="
    
    static let CATEGORY_GENERAL = "icon2016_general"
    static let CATEGORY_EVENTS = "icon2016_events"
    static let CATEGORY_EMERGENCY = "icon2016_emergency"
    static let CATEGORY_TEST = "icon2016_test"
    
    static let DEFAULT_CATEGORIES = [CATEGORY_GENERAL, CATEGORY_EVENTS, CATEGORY_EMERGENCY]
}
