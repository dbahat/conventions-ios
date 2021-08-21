//
//  Tickets.swift
//  Conventions
//
//  Created by Bahat, David on 21/09/2019.
//  Copyright © 2019 Amai. All rights reserved.
//

import Foundation

class Tickets {
    var userId: String
    var eventIds: Array<Int>
    var qrData: Data?
    
    convenience init() {
        self.init(userId: "", eventIds: [], qrData: nil)
    }
    
    init(userId: String, eventIds: Array<Int>, qrData: Data?) {
        self.userId = userId
        self.eventIds = eventIds
        self.qrData = qrData
    }
}
