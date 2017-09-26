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
    static let AttendingWasSetEventName = Notification.Name("AttendingWasSetEventName")
    
    private static let availableTicketsForEventUrl = "https://api.sf-f.org.il/program/available_tickets_per_event.php?slug=icon2017&id="
    
    var id: String
    var serverId: Int
    var color: UIColor?
    var textColor: UIColor?
    var title: String
    var lecturer: String?
    var startTime: Date
    var endTime: Date
    var type: EventType
    var hall: Hall
    var images: Array<Int>?
    var description: String?
    var category: String
    var price: Int
    var tags: Array<String>
    var url: URL
    var availableTickets: Int
    
    var availableTicketsLastModified: Date?
    
    let feedbackQuestions: Array<FeedbackQuestion> = [
        FeedbackQuestion(question:"האם נהנית באירוע?", answerType: .Smiley),
        FeedbackQuestion(question:"ההנחיה באירוע היתה:", answerType: .Smiley),
        FeedbackQuestion(question:"האם תרצה לבוא לאירועים בנושאים דומים בעתיד?", answerType: .Smiley),
        FeedbackQuestion(question:"עוד משהו?", answerType: .Text),
        ]
    
    init(id:String, serverId:Int, color: UIColor?, textColor: UIColor?, title: String, lecturer: String?, startTime: Date, endTime: Date, type: EventType, hall: Hall, description: String?, category: String, price: Int, tags: Array<String>, url: URL, availableTickets: Int) {
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
        self.url = url
        self.availableTickets = availableTickets
    }
    
    static func parse(_ json: Dictionary<String, AnyObject>, halls: Array<Hall>) -> ConventionEvent? {
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
            let tags = json["tags"] as? Array<String>,
            let url = json["url"] as? String,
            let availableTickets = json["availableTickets"] as? Int
        else {
            return nil
        }
        
        let event = ConventionEvent(id: id,
                               serverId: serverId,
                               color: Colors.eventTimeDefaultBackgroundColor,
                               textColor: nil,
                               title: title,
                               lecturer: lecturer,
                               startTime: Date(timeIntervalSince1970: startTime),
                               endTime: Date(timeIntervalSince1970: endTime),
                               type: EventType(backgroundColor: nil, description: type),
                               hall: ConventionEvent.findHall(halls, hallName: hall),
                               description: description,
                               category: category,
                               price: price,
                               tags: tags,
                               url: URL(string: url)!,
                               availableTickets: availableTickets)
        
        if let availableTicketsLastModified = json["availableTicketsLastModified"] as? Double {
            event.availableTicketsLastModified = Date(timeIntervalSince1970: availableTicketsLastModified)
        }
        
        return event
    }
    
    fileprivate static func findHall(_ halls: Array<Hall>, hallName: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == hallName}).first {
            return hall
        }
        
        return Hall(name: hallName, order: 100)
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        return [
            "id": self.id as AnyObject,
            "serverId": self.serverId as AnyObject,
            "title": self.title as AnyObject,
            "lecturer": (self.lecturer ?? "") as AnyObject,
            "startTime": self.startTime.timeIntervalSince1970 as AnyObject,
            "endTime": self.endTime.timeIntervalSince1970 as AnyObject,
            "type": self.type.description as AnyObject,
            "hall": self.hall.name as AnyObject,
            "description": (self.description ?? "") as AnyObject,
            "category": self.category as AnyObject,
            "price": self.price as AnyObject,
            "tags": self.tags as AnyObject,
            "url": self.url.absoluteString as AnyObject,
            "availableTickets": self.availableTickets as AnyObject,
            "availableTicketsLastModified": self.availableTicketsLastModified?.timeIntervalSince1970 as AnyObject
        ]
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
                
                NotificationCenter.default.post(name: ConventionEvent.AttendingWasSetEventName, object: self)
                
                GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Favorites",
                    action: newValue ? "Added" : "Remove",
                    label: "", value: NSNumber())
                    .build() as! [AnyHashable: Any]);
            } else {
                NotificationsSchedualer.removeEventAboutToStartNotification(self)
                NotificationsSchedualer.removeEventFeedbackReminderNotification(self)
            }
            
            if let input = Convention.instance.eventsInputs.getInput(id) {
                input.attending = newValue
                Convention.instance.eventsInputs.save()
                return
            }
            
            let input = UserInput.ConventionEventInput(attending: newValue, feedbackUserInput: UserInput.Feedback())
            Convention.instance.eventsInputs.setInput(input, forEventId: id)
            Convention.instance.eventsInputs.save()
        }
    }
    
    func provide(feedback answer: FeedbackAnswer) {
        
        if let input = Convention.instance.eventsInputs.getInput(id) {
            // If the answer already exists, override it
            if let existingAnswerIndex = input.feedbackUserInput.answers.index(where: {$0.questionText == answer.questionText}) {
                input.feedbackUserInput.answers.remove(at: existingAnswerIndex)
            }
            input.feedbackUserInput.answers.append(answer)
            Convention.instance.eventsInputs.save()
            return
        }
        
        let feedback = UserInput.Feedback()
        feedback.answers.append(answer)
        let input = UserInput.ConventionEventInput(attending: false, feedbackUserInput: feedback)
        
        Convention.instance.eventsInputs.setInput(input, forEventId: id)
        Convention.instance.eventsInputs.save()
    }
    
    func clear(feedback question: FeedbackQuestion) {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            // no inputs means nothing to clear
            return
        }
        
        guard let existingAnswerIndex = input.feedbackUserInput.answers.index(where: {$0.questionText == question.question}) else {
            // no existing answer means nothing to clear
            return
        }
        
        input.feedbackUserInput.answers.remove(at: existingAnswerIndex)
        Convention.instance.eventsInputs.save()
    }
    
    func submitFeedback(_ callback: ((_ success: Bool) -> Void)?) {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            // In case the user tries to submit empty feedback auto-fail the submission request
            callback?(false)
            return
        }
        
        Convention.instance.eventFeedbackForm.submit(
            conventionName: Convention.displayName,
            event: self,
            answers: input.feedbackUserInput.answers,
            callback: {success in
                input.feedbackUserInput.isSent = success
                
                let telemetryEvent = GAIDictionaryBuilder.createEvent(
                    withCategory: "Feedback",
                    action: "SendAttempt",
                    label: success ? "success" : "failure", value: NSNumber()).build() as! [AnyHashable: Any]
                
                GAI.sharedInstance().defaultTracker.send(telemetryEvent)
                
                callback?(success)
                })
    }
    
    func canFillFeedback() -> Bool {
        // Check if the event will end in 15 minutes or less
        return startTime.addMinutes(30).timeIntervalSince1970 < Date.now().timeIntervalSince1970
    }
    
    func didSubmitFeedback() -> Bool {
        guard let input = Convention.instance.eventsInputs.getInput(id) else {
            return false
        }
        
        return input.feedbackUserInput.isSent
    }
    
    func hasStarted() -> Bool {
        return startTime.timeIntervalSince1970 < Date.now().timeIntervalSince1970
    }
    
    func hasEnded() -> Bool {
        return endTime.timeIntervalSince1970 < Date.now().timeIntervalSince1970
    }
    
    func refreshAvailableTickets(_ callback:((_ success: Bool) -> Void)?) {
        let url = URL(string: ConventionEvent.availableTicketsForEventUrl + String(serverId))!
        
        URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) -> Void in
            
            guard
                let availableTicketsCallResponse = response as? HTTPURLResponse,
                let availableTicketsLastModifiedString = availableTicketsCallResponse.allHeaderFields["Last-Modified"] as? String,
                let unwrappedData = data
                
                else {
                    DispatchQueue.main.async {
                        callback?(false)
                    }
                    return
            }
            
            if (availableTicketsCallResponse.statusCode != 200) {
                DispatchQueue.main.async {
                    callback?(false)
                }
                return
            }
            
            guard
                let deserializedResult = try? JSONSerialization.jsonObject(with: unwrappedData, options: []) as? Dictionary<String, AnyObject>,
                let result = deserializedResult
                else {
                    print("Failed to deserialize available tickets result");
                    DispatchQueue.main.async {
                        callback?(false)
                    }
                    return
            }
            
            if let tickets = result["available_tickets"]  as? Int {
                self.availableTickets = tickets
            }
            self.availableTicketsLastModified = Date.parse(availableTicketsLastModifiedString, dateFormat: "EEE, dd MMM yyyy HH:mm:ss zzz")
            
            DispatchQueue.main.async {
                callback?(true)
            }
        }).resume()
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
