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
    
    func questionViewHeightChanged(caller caller: UITableViewCell, newHeight: CGFloat)
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
    
    // Since the question cell can change based on it's content, keep the delta from default here
    var cellHeightDelta = CGFloat(0)
    
    // Allow disabling the interactions inside the question cell
    var enabled = true
    
    /* abstract */ func questionDidSet(question: FeedbackQuestion) {}
    
    /* abstract */ func setAnswer(answer: FeedbackAnswer) {}
}