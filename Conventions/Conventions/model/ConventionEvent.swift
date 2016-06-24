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
    var title: String;
    var lecturer: String?;
    var startTime: NSDate;
    var endTime: NSDate;
    var type: EventType?;
    var hall: Hall;
    var images: Array<Int>?;
    var description: String?;
    
    let feedback = Feedback(questions: [
        FeedbackQuestion(question:"האם נהנית באירוע?", answerType: .Smiley),
        FeedbackQuestion(question:"ההנחיה באירוע היתה:", answerType: .Smiley),
        FeedbackQuestion(question:"האם תרצה לבוא לאירועים דומים בעתיד?", answerType: .Smiley),
        FeedbackQuestion(question:"עוד משהו?", answerType: .Text)
        ], userInput: Feedback.UserInput())
    
    var attending: Bool! {
        get {
            if let input = Convention.instance.userInputs.getInput(id) {
                return input.attending;
            }
            
            return false;
        }
        
        set {
            let input = UserInput(attending: newValue, feedbackUserInput: feedback.userInput ?? Feedback.UserInput());
            Convention.instance.userInputs.setInput(input, forEventId: id);
            
            if input.attending == true {
                NSNotificationCenter.defaultCenter().postNotificationName(ConventionEvent.AttendingWasSetEventName, object: self);
                addNotification();
            } else {
                removeNotification();
            }
        }
    }
    
    var userInput: UserInput? {
        get {
            return Convention.instance.userInputs.getInput(id);
        }
    }
    
    init(id:String, serverId:Int, color: UIColor?, textColor: UIColor?, title: String, lecturer: String?, startTime: NSDate, endTime: NSDate, type: EventType?, hall: Hall, description: String?) {
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
    
    private func addNotification() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings);
        
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None) {return;}
        
        // Don't schdule a notification in the past
        if (startTime.addMinutes(-5).timeIntervalSince1970 < NSDate().timeIntervalSince1970) {return;}
        
        let notification = UILocalNotification();
        notification.fireDate = startTime.addMinutes(-5);
        notification.timeZone = NSTimeZone.systemTimeZone();
        if #available(iOS 8.2, *) {
            notification.alertTitle = "אירוע עומד להתחיל"
        }
        notification.alertBody = String(format: "האירוע %@ עומד להתחיל ב%@", arguments: [title, hall.name]);
        notification.alertAction = "לפתיחת האירוע"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["EventId": id];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    private func removeNotification() {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard let userInfo = notification.userInfo else {continue;}
            guard let eventId = userInfo["EventId"] as? String else {continue;}
            if (eventId == id) {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
    
    class UserInput {
        var attending: Bool
        let feedbackUserInput: Feedback.UserInput
        
        init(attending: Bool, feedbackUserInput: Feedback.UserInput) {
            self.attending = attending
            self.feedbackUserInput = feedbackUserInput
        }
        
        init(json: Dictionary<String, AnyObject>) {
            if let attendingString = json["attending"] as? String {
                self.attending = NSString(string: attendingString).boolValue
            } else {
                self.attending = false
            }
            
            if let feedbackObject = json["feedback"] as? Dictionary<String, AnyObject> {
                self.feedbackUserInput = Feedback.UserInput(json: feedbackObject)
            } else {
                self.feedbackUserInput = Feedback.UserInput()
            }
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "attending": self.attending.description,
                "feedback": self.feedbackUserInput.toJson()]
        }
    }
}
