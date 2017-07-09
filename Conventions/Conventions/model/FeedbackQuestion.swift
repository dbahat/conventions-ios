//
//  FeedbackQuestion.swift
//  Conventions
//
//  Created by David Bahat on 6/18/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class FeedbackQuestion {
    var question: String
    let answerType: AnswerType
    let answersToSelectFrom: Array<String>?
    var viewHeight: CGFloat
    
    var answerChanged: Bool = false
    
    init(question: String, answerType: AnswerType, answersToSelectFrom: Array<String>? = nil) {
        self.question = question
        self.answerType = answerType
        self.answersToSelectFrom = answersToSelectFrom
        self.viewHeight = answerType.defaultHeight
    }
    
    enum AnswerType {
        case smiley
        case text
        case multipleAnswer
        case tableMultipleAnswer
        
        var defaultHeight: CGFloat {
            get {
                switch self {
                case .smiley:
                    return 102
                case .text:
                    return 102
                case .multipleAnswer:
                    return 60
                case .tableMultipleAnswer:
                    return 68
                }
            }
        }
    }
}
