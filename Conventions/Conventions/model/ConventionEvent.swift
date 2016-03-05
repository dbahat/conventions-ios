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
    
    /*
     * An NSNotification event, fired when a user decides to attend an event
     */
    static let AttendingWasSetEventName = "AttendingWasSetEventName";
    
    var id: String;
    var serverId: Int;
    var color: UIColor?;
    var textColor: UIColor?;
    var title: String?;
    var lecturer: String?;
    var startTime: NSDate;
    var endTime: NSDate;
    var type: EventType?;
    var hall: Hall;
    var images: Array<Int>?;
    var description: String?;
    
    var attending: Bool! {
        get {
            if let input = Convention.instance.userInputs.getInput(id) {
                return input.attending;
            }
            
            return false;
        }
        
        set {
            let input = UserInput(attending: newValue);
            Convention.instance.userInputs.setInput(input, forEventId: id);
            
            if input.attending == true {
                NSNotificationCenter.defaultCenter().postNotificationName(ConventionEvent.AttendingWasSetEventName, object: self);
            }
        }
    }
    
    var userInput: UserInput? {
        get {
            return Convention.instance.userInputs.getInput(id);
        }
    }
    
    init(id:String, serverId:Int, color: UIColor?, textColor: UIColor?, title: String?, lecturer: String?, startTime: NSDate, endTime: NSDate, type: EventType?, hall: Hall, description: String?) {
        self.id = id;
        self.serverId = serverId;
        self.color = color;
        self.textColor = textColor;
        self.title = title;
        self.lecturer = lecturer;
        self.startTime = startTime;
        self.endTime = endTime;
        self.type = type;
        self.hall = hall;
        self.description = description;
    }
    
    class UserInput {
        var attending: Bool!
        
        init(attending:Bool!) {
            self.attending = attending;
        }
        
        init(json: Dictionary<String, String>) {
            if let attendingString = json["attending"] {
                self.attending = NSString(string: attendingString).boolValue;
            }
        }
        
        func toJson() -> Dictionary<String, String> {
            return ["attending": attending.description];
        }
    }
}
