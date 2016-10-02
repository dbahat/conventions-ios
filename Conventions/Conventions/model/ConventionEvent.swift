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
    static let AttendingWasSetEventName = "AttendingWasSetEventName"
    
    var id: String
    var serverId: Int
    var color: UIColor?
    var textColor: UIColor?
    var title: String
    var lecturer: String?
    var startTime: NSDate
    var endTime: NSDate
    var type: EventType
    var hall: Hall
    var images: Array<Int>?
    var description: String?
    var category: String
    var price: Int
    var tags: Array<String>
    
    let feedbackQuestions: Array<FeedbackQuestion> = [
        FeedbackQuestion(question:"האם נהנית באירוע?", answerType: .Smiley),
        FeedbackQuestion(question:"ההנחיה באירוע היתה:", answerType: .Smiley),
        FeedbackQuestion(question:"האם תרצה לבוא לאירועים דומים בעתיד?", answerType: .Smiley),
        FeedbackQuestion(question:"עוד משהו?", answerType: .Text),
        ]
    
    init(id:String, serverId:Int, color: UIColor?, textColor: UIColor?, title: String, lecturer: String?, startTime: NSDate, endTime: NSDate, type: EventType, hall: Hall, description: String?, category: String, price: Int, tags: Array<String>) {
        self.id = id
        self.serverId = serverId
        self.color = color
        self.textColor = textColor
        self.title = title
        self.lecturer = lecturer
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.hall = hall
        self.description = description
        self.category = category
        self.price = price
        self.tags = tags
    }
    
    static func parse(json: Dictionary<String, AnyObject>, halls: Array<Hall>) -> ConventionEvent? {
        guard
            let id = json["id"] as? String,
            let serverId = json["serverId"] as? Int,
            let title = json["title"] as? String,
            let lecturer = json["lecturer"] as? String,
            let startTime = json["startTime"] as? Double,
            let endTime = json["endTime"] as? Double,
            let type = json["type"] as? String,
            let hall = json["hall"] as? String,
            let description = json["description"] as? String,
            let category = json["category"] as? String,
            let price = json["price"] as? Int,
            let tags = json["tags"] as? Array<String>
        else {
            return nil
        }
        
        return ConventionEvent(id: id,
                               serverId: serverId,
                               color: Colors.eventTimeDefaultBackgroundColor,
                               textColor: nil,
                               title: title,
                               lecturer: lecturer,
                               startTime: NSDate(timeIntervalSince1970: startTime),
                               endTime: NSDate(timeIntervalSince1970: endTime),
                               type: EventType(backgroundColor: nil, description: type),
                               hall: ConventionEvent.findHall(halls, hallName: hall),
                               description: description,
                               category: category,
                               price: price,
                               tags: tags)
    }
    
    private static func findHall(halls: Array<Hall>, hallName: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == hallName}).first {
            return hall
        }
        
        return Hall(name: hallName, order: 100)
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        return [
            "id": self.id,
            "serverId": self.serverId,
            "title": self.title,
            "lecturer": self.lecturer ?? "",
            "startTime": self.startTime.timeIntervalSince1970,
            "endTime": self.endTime.timeIntervalSince1970,
            "type": self.type.description,
            "hall": self.hall.name,
            "description": self.description ?? "",
            "category": self.category,
            "price": self.price,
            "tags": self.tags]
    }
    
    var feedbackAnswers: Array<FeedbackAnswer> {
        get {
            guard let input = Convention.instance.eventsInputs.getInput(id) else {
                return []
            }
            
            return input.feedbackUserInput.answers
        }
    }
    
    var attending: Bool {
        get {
            guard let input = Convention.instance.eventsInputs.getInput(id) else {
                return false
            }
            
            return input.attending
        }
        
        set {
            if newValue {
                NotificationsSchedualer.scheduleEventAboutToStartNotification(self)
                NotificationsSchedualer.scheduleEventFeedbackReminderNotification(self)
                
                NSNotificationCenter.defaultCenter().postNotificationName(ConventionEvent.AttendingWasSetEventName, object: self)
                
                GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("Favorites",
                    action: newValue ? "Added" : "Remove",
                    label: "", value: NSNumber())
                    .build() as [NSObject: AnyObject]);
            } else {
                NotificationsSchedualer.removeEventAboutToStartNotification(self)
                NotificationsSchedualer.removeEventFeedbackReminderNotification(self)
            }
            
            if let input = Convention.instance.eventsInputs.getInput(id) {
                input.attending = newValue
                Convention.instance.eventsInputs.save()
                return
            }
            
            let input = UserInput.ConventionEvent(attending: newValue, feedbackUserInput: UserInput.Feedback())
            Convention.instance.eventsInputs.setInput(input, forEventId: id)
            Convention.instance.eventsInputs.save()
        }
    }
    
    func provide(feedback answer: FeedbackAnswer) {
        
        if let input = Convention.instance.eventsInputs.getInput(id) {
            // If the answer already exists, override it
            if let existingAnswerIndex = input.feedbackUserInput.answers.indexOf({$0.questionText == answer.questionText}) {
                input.feedbackUserInput.answers.removeAtIndex(existingAnswerIndex)
            }
            input.feedbackUserInput.answers.append(answer)
            Convention.instance.eventsInputs.save()
            return
        }
        
        let feedback = UserInput.Feedback()
        feedback.answers.append(answer)
        let input = UserInput.ConventionEvent(attending: false, feedbackUserInput: feedback)
        
        Convention.instance.eventsInputs.setInput(input, forEventId: id)
        Convention.instance.eventsInputs.save()
    }
    
    func clear(feedback question: FeedbackQuestion) {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            // no inputs means nothing to clear
            return
        }
        
        guard let existingAnswerIndex = input.feedbackUserInput.answers.indexOf({$0.questionText == question.question}) else {
            // no existing answer means nothing to clear
            return
        }
        
        input.feedbackUserInput.answers.removeAtIndex(existingAnswerIndex)
        Convention.instance.eventsInputs.save()
    }
    
    func submitFeedback(callback: ((success: Bool) -> Void)?) {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            // In case the user tries to submit empty feedback auto-fail the submission request
            callback?(success: false)
            return
        }
        
        input.feedbackUserInput.submit("פידבק ל" + Convention.displayName + " עבור האירוע: " + title,
                                       bodyOpening: String(format: "%@\n%@, %@\n\n",
                                        title,
                                        startTime.format("dd.MM.yyyy HH:mm"),
                                        hall.name),
                                       callback: callback)
    }
    
    func canFillFeedback() -> Bool {
        // Check if the event will end in 15 minutes or less
        return NSDate().compare(endTime.addMinutes(-15)) == .OrderedDescending
    }
    
    func didSubmitFeedback() -> Bool {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            return false
        }
        
        return input.feedbackUserInput.isSent
    }
}

extension Array where Element: FeedbackAnswer {
    // "Weighted rating" represents the overall rating the user gave to this event amongst the smiley
    // questions
    func getFeedbackWeightedRating() -> FeedbackAnswer.Smiley? {
        // We assume the smiley questions are sorted by importance
        return self
            .filter({answer in answer as? FeedbackAnswer.Smiley != nil})
            .map({answer in answer as! FeedbackAnswer.Smiley})
            .first
    }
}
