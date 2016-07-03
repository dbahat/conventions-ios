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
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
    }
    
    @IBAction private func veryPositiveWasClicked(sender: UIButton) {
        setState(.VeryPositive, sender: sender)
    }
    @IBAction private func positiveWasClicked(sender: UIButton) {
        setState(.Positive, sender: sender)
    }
    @IBAction private func negetiveWasClicked(sender: UIButton) {
        setState(.Negetive, sender: sender)
    }
    
    private func setState(newState: FeedbackAnswer.Smiley.SmileyType, sender: UIButton) {
        
        if sender.selected {
            // In case the user clicked on an already selected button, clear the selection
            sender.selected = false
            delegate?.questionCleared(question!) // ok to force unwrap here, since the user can only click a button if we've set a question
            return
        }
        
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