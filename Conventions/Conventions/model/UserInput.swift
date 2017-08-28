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
        
        func submit(_ title: String, bodyOpening: String, callback: ((_ success: Bool) -> Void)?) {
            
            let session = MCOSMTPSession();
            session.hostname = "smtp.gmail.com"
            session.port = 465
            session.username = FeedbackMailInfo.mailbox
            session.password = FeedbackMailInfo.password
            session.connectionType = MCOConnectionType.TLS
            
            let builder = MCOMessageBuilder();
            builder.header.from = MCOAddress(mailbox: FeedbackMailInfo.mailbox)
            builder.header.to = [MCOAddress(mailbox: Convention.mailbox)]
            builder.header.subject = "מייל אוטומטי -  " + title
            
            var formattedAnswers = bodyOpening + answers.map({
                String(format: "%@\n%@", $0.questionText, $0.getAnswer())
            }).joined(separator: "\n\t\n\t\n")
            
            // Attaching device id to mails to allow basic fraud detection
            if let deviceId = UIDevice.current.identifierForVendor {
                formattedAnswers.append(String(format: "\n\t\n\t\n\t\nDeviceId:\n%@", deviceId.uuidString))
            }
            
            builder.textBody = formattedAnswers
            
            self.isSent = true
            callback?(true)
            let operation = session.sendOperation(with: builder.data());
            operation?.start { error in
                
                GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Feedback",
                    action: "SendAttempt",
                    label: error != nil ? "success" : "failure", value: NSNumber())
                    .build() as! [AnyHashable: Any]);
                
                if error != nil {
                    callback?(false)
                } else {
                    self.isSent = true
                    callback?(true)
                }
            }
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
