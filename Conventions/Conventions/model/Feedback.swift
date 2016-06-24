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
    let userInput: UserInput?
    
    init(questions : Array<FeedbackQuestion>, userInput: UserInput?) {
        self.questions = questions
        self.userInput = userInput
    }
    
    func provide(answer answer: FeedbackAnswer) {
        if let existingAnswerIndex = self.userInput?.answers.indexOf({$0.questionText == answer.questionText}) {
            self.userInput?.answers.removeAtIndex(existingAnswerIndex)
        }
        self.userInput?.answers.append(answer)
    }
    
    func get(answerToQuestion question: FeedbackQuestion) -> FeedbackAnswer? {
        return self.userInput?.answers.filter({$0.questionText == question.question}).first
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