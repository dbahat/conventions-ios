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
    
    var answerChanged: Bool = false
    
    init(question: String, answerType: AnswerType, answersToSelectFrom: Array<String>? = nil) {
        self.question = question
        self.answerType = answerType
        self.answersToSelectFrom = answersToSelectFrom
    }
    
    enum AnswerType {
        case Smiley
        case Text
        case MultipleAnswersRadioButton
        case MultipleAnswersChecklist
    }
}