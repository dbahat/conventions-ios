//
//  FeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol FeedbackQuestionProtocol : class {
    func questionWasAnswered(_ answer: FeedbackAnswer)
    
    func questionCleared(_ question: FeedbackQuestion)
    
    func questionViewHeightChanged(caller: UITableViewCell, newHeight: CGFloat)
}

/* abstract */ class FeedbackQuestionCell : UITableViewCell {
    var question: FeedbackQuestion? {
        didSet {
            if let feedbackQuestion = question {
                questionDidSet(feedbackQuestion)
            }
        }
    }
    weak var delegate: FeedbackQuestionProtocol?
    
    // Since the question cell can change based on it's content, keep the delta from default here
    var cellHeightDelta = CGFloat(0)
    
    // Allow disabling the interactions inside the question cell
    var enabled = true
    
    var feedbackTextColor = Colors.textColor
    var feedbackAnswerColor = Colors.feedbackButtonColorConvetion
    var feedbackAnswerPressedColor = Colors.feedbackButtonPressedColor
    
    /* abstract */ func questionDidSet(_ question: FeedbackQuestion) {}
    
    /* abstract */ func setAnswer(_ answer: FeedbackAnswer) {}
}
