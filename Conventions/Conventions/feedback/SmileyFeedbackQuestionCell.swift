//
//  SmileyFeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class SmileyFeedbackQuestionCell : FeedbackQuestionCell {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var positiveFeedbackButton: UIButton!
    @IBOutlet private weak var negetiveFeedbackButton: UIButton!
    @IBOutlet private weak var veryPositiveFeedbackButton: UIButton!
    
    override var enabled: Bool {
        didSet {
            positiveFeedbackButton.userInteractionEnabled = enabled
            negetiveFeedbackButton.userInteractionEnabled = enabled
            veryPositiveFeedbackButton.userInteractionEnabled = enabled
        }
    }
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
    }
    
    override func setAnswer(answer: FeedbackAnswer) {
        guard let smilyAnswer = answer as? FeedbackAnswer.Smiley else {
            return
        }
        
        setState(smilyAnswer.answer)
    }
    
    @IBAction private func veryPositiveWasClicked(sender: UIButton) {
        resetState(button: sender, newState: .VeryPositive)
    }
    @IBAction private func positiveWasClicked(sender: UIButton) {
        resetState(button: sender, newState: .Positive)
    }
    @IBAction private func negetiveWasClicked(sender: UIButton) {
        resetState(button: sender, newState: .Negetive)
    }
    
    private func resetState(button button: UIButton, newState: FeedbackAnswer.Smiley.SmileyType) {
        // In case the user clicked on an already selected button, clear the selection
        if button.selected {
            button.selected = false
            if let unwrappedQuestion = question {
                delegate?.questionCleared(unwrappedQuestion)
            }
            return
        }
        
        setState(newState)
    }
    
    private func setState(newState: FeedbackAnswer.Smiley.SmileyType) {
        negetiveFeedbackButton.selected = false
        positiveFeedbackButton.selected = false
        veryPositiveFeedbackButton.selected = false
        
        switch newState {
        case .Negetive:
            negetiveFeedbackButton.selected = true
            break;
        case .Positive:
            positiveFeedbackButton.selected = true
            break;
        case .VeryPositive:
            veryPositiveFeedbackButton.selected = true
            break;
        }
        
        delegate?.questionWasAnswered(FeedbackAnswer.Smiley(questionText: question!.question, answer: newState))
    }
}