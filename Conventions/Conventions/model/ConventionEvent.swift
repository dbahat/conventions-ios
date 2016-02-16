//
//  ConventionEvent.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

class ConventionEvent {
    var id: String!;
    var serverId: Int?;
    var color: UIColor?;
    var title: String?;
    var lecturer: String?;
    var startTime: NSDate!;
    var endTime: NSDate!;
    var type: EventType?;
    var hall: Hall?;
    var images: Array<Int>?;
    var description: String?;
    var attending: Bool!;
    
    init(id:String!, serverId:Int?, color: UIColor?, title: String?, lecturer: String?, startTime: NSDate!, endTime: NSDate!, type: EventType?, hall: Hall?, description: String?) {
        self.id = id;
        self.serverId = serverId;
        self.color = color;
        self.title = title;
        self.lecturer = lecturer;
        self.startTime = startTime;
        self.endTime = endTime;
        self.type = type;
        self.hall = hall;
        self.description = description;
        self.attending = false;
    }
}
