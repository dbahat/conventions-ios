//
//  Feedback.swift
//  Conventions
//
//  Created by David Bahat on 6/18/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Feedback {
    let questions: Array<FeedbackQuestion>
    let userInput: UserInput
    
    init(questions : Array<FeedbackQuestion>, userInput: UserInput) {
        self.questions = questions
        self.userInput = userInput
    }
    
    func provide(answer answer: FeedbackAnswer) {
        if let existingAnswerIndex = self.userInput.answers.indexOf({$0.questionText == answer.questionText}) {
            self.userInput.answers.removeAtIndex(existingAnswerIndex)
        }
        self.userInput.answers.append(answer)
    }
    
    func get(answerToQuestion question: FeedbackQuestion) -> FeedbackAnswer? {
        return self.userInput.answers.filter({$0.questionText == question.question}).first
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
        
        var answers = userInput.answers.map({
            String(format: "%@\n%@", $0.questionText, $0.getAnswer())
        }).joinWithSeparator("\n\t\n\t\n")
        
        // Attaching device id to mails to allow basic fraud detection
        if let deviceId = UIDevice.currentDevice().identifierForVendor {
            answers.appendContentsOf(String(format: "\n\t\n\t\nDeviceId:\n%@", deviceId.UUIDString))
        }
        
        builder.textBody = answers
        
        let operation = session.sendOperationWithData(builder.data());
        operation.start { error in
            if error != nil {
                callback?(success: false)
            } else {
                self.userInput.isSent = true
                callback?(success: true)
            }
        }
    }
    
    class UserInput {
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
    }
}