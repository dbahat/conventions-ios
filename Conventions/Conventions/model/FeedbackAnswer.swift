//
//  FeedbackAnswer.swift
//  Conventions
//
//  Created by David Bahat on 6/19/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

/* abstract */ class FeedbackAnswer {
    
    let questionText : String
    
    init(questionText: String) {
        self.questionText = questionText
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        return ["question": questionText]
    }
    
    func getAnswer() -> String {
        return ""
    }
    
    static func parse(json: Dictionary<String, AnyObject>) -> FeedbackAnswer? {
        guard let type = json["type"] as? String else {
            return nil
        }
        guard let questionText = json["question"] as? String else {
            return nil
        }
        
        switch type {
        case String(FeedbackAnswer.Text.self):
            guard let answer = json["answer"] as? String else {
                return nil
            }
            return Text(questionText: questionText, answer: answer)
        case String(FeedbackAnswer.Smiley.self):
            guard let answerText = json["answer"] as? String else {
                return nil
            }
            guard let answer = FeedbackAnswer.Smiley.SmileyType.parse(answerText) else {
                return nil
            }
            return Smiley(questionText: questionText, answer: answer)
        default:
            return nil
        }
    }
    
    class Text : FeedbackAnswer {
        var answer: String
        
        init(questionText: String, answer: String) {
            self.answer = answer
            super.init(questionText: questionText)
        }
        
        override func toJson() -> Dictionary<String, AnyObject> {
            var json = super.toJson();
            json["answer"] = self.answer
            json["type"] = String(FeedbackAnswer.Text.self)
            return json
        }
        
        override func getAnswer() -> String {
            return answer
        }
    }
    
    class Smiley : FeedbackAnswer {
        var answer: SmileyType
        
        init(questionText: String, answer: SmileyType) {
            self.answer = answer
            super.init(questionText: questionText)
        }
        
        override func toJson() -> Dictionary<String, AnyObject> {
            var json = super.toJson();
            json["answer"] = self.answer.description()
            json["type"] = String(FeedbackAnswer.Smiley.self)
            return json
        }
        
        override func getAnswer() -> String {
            return answer.description()
        }
        
        enum SmileyType {
            case Negetive
            case Positive
            case VeryPositive
            
            func getImage() -> UIImage {
                switch self {
                case .Negetive:
                    return UIImage(named: "feedback_negetive")!
                case .Positive:
                    return UIImage(named: "feedback_positive")!
                case .VeryPositive:
                    return UIImage(named: "feedback_very_positive")!
                }
            }
            
            func description() -> String {
                switch self {
                case .Negetive:
                    return ":("
                case .Positive:
                    return ":)"
                case .VeryPositive:
                    return ":D"
                }
            }
            
            static func parse(value: String?) -> SmileyType? {
                guard let unwrappedValue = value else {
                    return nil
                }
                
                switch unwrappedValue {
                case ":(":
                    return .Negetive
                case ":)":
                    return .Positive
                case ":D":
                    return .VeryPositive
                default:
                    return nil
                }
            }
        }
    }
}