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
    static let CONNECTIONSTRING = "Endpoint=sb://conventions.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=hjyET8pIKJ2VZNFkcuvFDt6tZ/aSS57eMSNIU2WofSM="
    
    static let CATEGORY_GENERAL = "cami2016_general"
    static let CATEGORY_EVENTS = "cami2016_events"
    static let CATEGORY_COSPLAY = "cami2016_cosplay"
    static let CATEGORY_BUS = "cami2016_bus"
    static let CATEGORY_EMERGENCY = "cami2016_emergency"
    static let CATEGORY_TEST = "cami2016_test"
    
    static let DEFAULT_CATEGORIES = [CATEGORY_GENERAL, CATEGORY_EVENTS, CATEGORY_EMERGENCY]
}