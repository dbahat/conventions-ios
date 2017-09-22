//
//  SmileyFeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class SmileyFeedbackQuestionCell : FeedbackQuestionCell {
    
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var positiveFeedbackButton: UIButton!
    @IBOutlet fileprivate weak var negetiveFeedbackButton: UIButton!
    @IBOutlet fileprivate weak var veryPositiveFeedbackButton: UIButton!
    
    override var enabled: Bool {
        didSet {
            positiveFeedbackButton.isUserInteractionEnabled = enabled
            negetiveFeedbackButton.isUserInteractionEnabled = enabled
            veryPositiveFeedbackButton.isUserInteractionEnabled = enabled
        }
    }
    
    override var feedbackTextColor: UIColor {
        didSet {
            questionLabel.textColor = feedbackTextColor
        }
    }
    
    override func questionDidSet(_ question: FeedbackQuestion) {
        questionLabel.text = question.question
    }
    
    override func setAnswer(_ answer: FeedbackAnswer) {
        guard let smilyAnswer = answer as? FeedbackAnswer.Smiley else {
            return
        }
        
        setState(smilyAnswer.answer)
    }
    
    @IBAction fileprivate func veryPositiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .veryPositive)
    }
    @IBAction fileprivate func positiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .positive)
    }
    @IBAction fileprivate func negetiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .negetive)
    }
    
    fileprivate func resetState(button: UIButton, newState: FeedbackAnswer.Smiley.SmileyType) {
        // In case the user clicked on an already selected button, clear the selection
        if button.isSelected {
            button.isSelected = false
            if let unwrappedQuestion = question {
                delegate?.questionCleared(unwrappedQuestion)
            }
            return
        }
        
        setState(newState)
    }
    
    fileprivate func setState(_ newState: FeedbackAnswer.Smiley.SmileyType) {
        negetiveFeedbackButton.isSelected = false
        positiveFeedbackButton.isSelected = false
        veryPositiveFeedbackButton.isSelected = false
        
        switch newState {
        case .negetive:
            negetiveFeedbackButton.isSelected = true
            break;
        case .positive:
            positiveFeedbackButton.isSelected = true
            break;
        case .veryPositive:
            veryPositiveFeedbackButton.isSelected = true
            break;
        }
        
        delegate?.questionWasAnswered(FeedbackAnswer.Smiley(questionText: question!.question, answer: newState))
    }
}
