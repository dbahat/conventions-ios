//
//  UserInput.swift
//  Conventions
//
//  Created by David Bahat on 7/20/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class UserInput {
    class Feedback {
        var answers: Array<FeedbackAnswer> = []
        var isSent: Bool = false
        
        init() {
        }
        
        init(json: Dictionary<String, AnyObject>) {
            
            if let isSentString = json["isSent"] as? String {
                self.isSent = NSString(string: isSentString).boolValue
            }
            
            if let answersArray = json["answers"] as? Array<Dictionary<String, AnyObject>> {
                var result = Array<FeedbackAnswer>();
                for answer in answersArray {
                    if let feedbackAnswer = FeedbackAnswer.parse(answer) {
                        result.append(feedbackAnswer)
                    }
                }
                
                self.answers = result
            }
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "isSent": isSent.description as AnyObject,
                "answers": answers.map({$0.toJson()}) as AnyObject
            ]
        }
    }
    
    class ConventionEventInput {
        
        var attending: Bool
        var feedbackUserInput: UserInput.Feedback
        
        init(attending: Bool, feedbackUserInput: UserInput.Feedback) {
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
                self.feedbackUserInput = UserInput.Feedback(json: feedbackObject)
            } else {
                self.feedbackUserInput = UserInput.Feedback()
            }
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "attending": self.attending.description as AnyObject,
                "feedback": self.feedbackUserInput.toJson() as AnyObject]
        }
    }
}
