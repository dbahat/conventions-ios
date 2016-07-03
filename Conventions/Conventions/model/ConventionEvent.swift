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
    
    let feedbackQuestions: Array<FeedbackQuestion> = [
        FeedbackQuestion(question:"האם נהנית באירוע?", answerType: .Smiley),
        FeedbackQuestion(question:"ההנחיה באירוע היתה:", answerType: .Smiley),
        FeedbackQuestion(question:"האם תרצה לבוא לאירועים דומים בעתיד?", answerType: .Smiley),
        FeedbackQuestion(question:"עוד משהו?", answerType: .Text)
        ]
    
    var feedbackAnswers: Array<FeedbackAnswer> {
        get {
            guard let input = Convention.instance.userInputs.getInput(id) else {
                return []
            }
            
            return input.feedbackUserInput.answers
        }
    }
    
    var attending: Bool {
        get {
            guard let input = Convention.instance.userInputs.getInput(id) else {
                return false
            }
            
            return input.attending
        }
        
        set {
            if let input = Convention.instance.userInputs.getInput(id) {
                input.attending = newValue
                Convention.instance.userInputs.save()
                return
            }
            
            let input = UserInputs.ConventionEvent(attending: newValue, feedbackUserInput: UserInputs.ConventionEvent.Feedback())
            Convention.instance.userInputs.setInput(input, forEventId: id)
            Convention.instance.userInputs.save()
            
            if input.attending {
                NSNotificationCenter.defaultCenter().postNotificationName(ConventionEvent.AttendingWasSetEventName, object: self);
                addEventNotifications();
            } else {
                removeEventNotifications();
            }
        }
    }
    
    func provide(feedback answer: FeedbackAnswer) {
        
        if let input = Convention.instance.userInputs.getInput(id) {
            // If the answer already exists, override it
            if let existingAnswerIndex = input.feedbackUserInput.answers.indexOf({$0.questionText == answer.questionText}) {
                input.feedbackUserInput.answers.removeAtIndex(existingAnswerIndex)
            }
            input.feedbackUserInput.answers.append(answer)
            Convention.instance.userInputs.save()
            return
        }
        
        let feedback = UserInputs.ConventionEvent.Feedback()
        feedback.answers.append(answer)
        let input = UserInputs.ConventionEvent(attending: false, feedbackUserInput: feedback)
        Convention.instance.userInputs.setInput(input, forEventId: id)
        Convention.instance.userInputs.save()
    }
    
    func clear(feedback question: FeedbackQuestion) {
        guard let input = Convention.instance.userInputs.getInput(id) else {
            // no inputs means nothing to clear
            return
        }
        
        guard let existingAnswerIndex = input.feedbackUserInput.answers.indexOf({$0.questionText == question.question}) else {
            // no existing answer means nothing to clear
            return
        }
        
        input.feedbackUserInput.answers.removeAtIndex(existingAnswerIndex)
        Convention.instance.userInputs.save()
    }
    
    func submitFeedback(callback: ((success: Bool) -> Void)?) {
        guard let input = Convention.instance.userInputs.getInput(id) else {
            // In case the user tries to submit empty feedback auto-fail the submission request
            callback?(success: false)
            return
        }
        
        input.feedbackUserInput.submit(title, callback: callback)
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
    
    private func addEventNotifications() {
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
    
    private func removeEventNotifications() {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return;};
        
        for notification in notifications {
            guard let userInfo = notification.userInfo else {continue;}
            guard let eventId = userInfo["EventId"] as? String else {continue;}
            if (eventId == id) {
                UIApplication.sharedApplication().cancelLocalNotification(notification);
            }
        }
    }
}
