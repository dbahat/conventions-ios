//
//  UserInputs.swift
//  Conventions
//
//  Created by David Bahat on 2/20/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class UserInputs {
    private static let storageFileName = Convention.name + "UserInputs.json";
    private static let storageFile = NSHomeDirectory() + "/Documents/" + UserInputs.storageFileName;
    
    // Maps eventId to the user input for that event
    private var eventInputs = Dictionary<String, UserInputs.ConventionEvent>();
    
    init() {
        // Try to load the cached user inputs upon init
        if let cachedInputs = load() {
            eventInputs = cachedInputs;
        }
    }
    
    func getInput(forEventId: String) -> UserInputs.ConventionEvent? {
        return eventInputs[forEventId];
    }
    
    func setInput(input: UserInputs.ConventionEvent, forEventId: String) {
        eventInputs[forEventId] = input;
    }
    
    func save() {
        let serilizableInputs = eventInputs.map({input in [input.0: input.1.toJson()]});
        
        let json = try? NSJSONSerialization.dataWithJSONObject(serilizableInputs, options: NSJSONWritingOptions.PrettyPrinted);
        json?.writeToFile(UserInputs.storageFile, atomically: true);
    }
    
    private func load() -> Dictionary<String, UserInputs.ConventionEvent>? {
        guard let storedInputs = NSData(contentsOfFile: UserInputs.storageFile) else {
            return nil;
        }
        guard let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments) else {
            return nil;
        }
        guard let userInputs = userInputsJson as? [Dictionary<String, Dictionary<String, AnyObject>>] else {
            return nil;
        }
        
        var result = Dictionary<String, UserInputs.ConventionEvent>();
        for userInput in userInputs {
            userInput.forEach({input in result[input.0] = UserInputs.ConventionEvent(json: input.1)})
        }
        return result
    }
    
    class ConventionEvent {
        
        var attending: Bool
        var feedbackUserInput: ConventionEvent.Feedback
        
        init(attending: Bool, feedbackUserInput: ConventionEvent.Feedback) {
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
                self.feedbackUserInput = ConventionEvent.Feedback(json: feedbackObject)
            } else {
                self.feedbackUserInput = ConventionEvent.Feedback()
            }
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "attending": self.attending.description,
                "feedback": self.feedbackUserInput.toJson()]
        }
        
        class Feedback {
            var answers: Array<FeedbackAnswer> = []
            var isSent: Bool = false;
            
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
    }
}