//
//  FeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol FeedbackQuestionProtocol : class {
    func questionWasAnswered(answer: FeedbackAnswer)
    
    func questionCleared(question: FeedbackQuestion)
}

/* abstract */ class FeedbackQuestionCell : UITableViewCell {
    var question: FeedbackQuestion? {
        didSet {
            if let feedbackQuestion = question {
                questionDidSet(feedbackQuestion)
            }
        }
    }
    var delegate: FeedbackQuestionProtocol?
    
    /* abstract */ func questionDidSet(question: FeedbackQuestion) {
        
    }
}