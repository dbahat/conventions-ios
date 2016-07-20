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
                "isSent": isSent.description,
                "answers": answers.map({$0.toJson()})
            ]
        }
        
        func submit(title: String, callback: ((success: Bool) -> Void)?) {
            
            let session = MCOSMTPSession();
            session.hostname = "smtp.gmail.com"
            session.port = 465
            session.username = FeedbackMailInfo.mailbox
            session.password = FeedbackMailInfo.password
            session.connectionType = MCOConnectionType.TLS
            
            let builder = MCOMessageBuilder();
            builder.header.from = MCOAddress(mailbox: FeedbackMailInfo.mailbox)
            builder.header.to = [MCOAddress(mailbox: Convention.mailbox)]
            builder.header.subject = "מייל אוטומטי - פידבק עבור האירוע " + title
            
            var formattedAnswers = answers.map({
                String(format: "%@\n%@", $0.questionText, $0.getAnswer())
            }).joinWithSeparator("\n\t\n\t\n")
            
            // Attaching device id to mails to allow basic fraud detection
            if let deviceId = UIDevice.currentDevice().identifierForVendor {
                formattedAnswers.appendContentsOf(String(format: "\n\t\n\t\nDeviceId:\n%@", deviceId.UUIDString))
            }
            
            builder.textBody = formattedAnswers
            
            self.isSent = true
            callback?(success: true)
            let operation = session.sendOperationWithData(builder.data());
            operation.start { error in
                if error != nil {
                    callback?(success: false)
                } else {
                    self.isSent = true
                    callback?(success: true)
                }
            }
        }
    }
    
    class ConventionEvent {
        
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
                "attending": self.attending.description,
                "feedback": self.feedbackUserInput.toJson()]
        }
    }
}