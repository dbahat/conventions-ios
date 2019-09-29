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
        return ["question": questionText as AnyObject]
    }
    
    func getAnswer() -> String {
        return ""
    }
    
    static func parse(_ json: Dictionary<String, AnyObject>) -> FeedbackAnswer? {
        guard let type = json["type"] as? String else {
            return nil
        }
        guard let questionText = json["question"] as? String else {
            return nil
        }
        
        switch type {
        case String(describing: FeedbackAnswer.Text.self):
            guard let answer = json["answer"] as? String else {
                return nil
            }
            return Text(questionText: questionText, answer: answer)
        case String(describing: FeedbackAnswer.Smiley.self):
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
            json["answer"] = self.answer as AnyObject
            json["type"] = String(describing: FeedbackAnswer.Text.self) as AnyObject
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
            json["answer"] = self.answer.description() as AnyObject
            json["type"] = String(describing: FeedbackAnswer.Smiley.self) as AnyObject
            return json
        }
        
        override func getAnswer() -> String {
            return answer.description()
        }
        
        enum SmileyType {
            case veryNegetive
            case negetive
            case neutral
            case positive
            case veryPositive
            
            func getImage() -> UIImage {
                switch self {
                case .veryNegetive:
                    return UIImage(named: "Feedback_very_negetive")!.withRenderingMode(.alwaysTemplate)
                case .negetive:
                    return UIImage(named: "Feedback_negetive")!.withRenderingMode(.alwaysTemplate)
                case .neutral:
                    return UIImage(named: "Feedback_neutral")!.withRenderingMode(.alwaysTemplate)
                case .positive:
                    return UIImage(named: "Feedback_positive")!.withRenderingMode(.alwaysTemplate)
                case .veryPositive:
                    return UIImage(named: "Feedback_very_positive")!.withRenderingMode(.alwaysTemplate)
                }
            }
            
            func description() -> String {
                switch self {
                case .veryNegetive:
                    return "☹️"
                case .negetive:
                    return "🙁"
                case .neutral:
                    return "😐"
                case .positive:
                    return "🙂"
                case .veryPositive:
                    return "😃"
                }
            }
            
            static func parse(_ value: String?) -> SmileyType? {
                guard let unwrappedValue = value else {
                    return nil
                }
                
                switch unwrappedValue {
                case "☹️":
                    return .veryNegetive
                case "🙁":
                    return .negetive
                case "😐":
                    return .neutral
                case "🙂":
                    return .positive
                case "😃":
                    return .veryPositive
                default:
                    print("unidentified answer type while parsing: " + unwrappedValue)
                    return nil
                }
            }
        }
    }
}
