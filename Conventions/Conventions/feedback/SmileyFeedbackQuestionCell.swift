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
    @IBOutlet private weak var neutralFeedbackButton: UIButton!
    @IBOutlet private weak var veryNegetiveFeedbackButton: UIButton!
    
    override var enabled: Bool {
        didSet {
            for button in getButtons() {
                button.isUserInteractionEnabled = enabled
            }
        }
    }
    
    override var feedbackTextColor: UIColor {
        didSet {
            questionLabel.textColor = feedbackTextColor
        }
    }
    
    override var feedbackAnswerColor : UIColor {
        didSet {
            for button in getButtons() {
                let image = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
                button.setImage(image, for: .normal)
                button.tintColor = feedbackAnswerColor
            }
        }
    }
    
    override func questionDidSet(_ question: FeedbackQuestion) {
        questionLabel.text = question.question
        
        for button in getButtons() {
            let selectedImage = UIImage(named: "FeedbackRatingFull")?.withRenderingMode(.alwaysTemplate).withTintColor(feedbackAnswerColor)
            button.setImage(selectedImage, for: .selected)
            let notSelectedImage = UIImage(named: "FeedbackRatingEmpty")?.withRenderingMode(.alwaysTemplate).withTintColor(feedbackAnswerColor)
            button.setImage(notSelectedImage, for: .normal)
        }
    }
    
    override func setAnswer(_ answer: FeedbackAnswer) {
        guard let smilyAnswer = answer as? FeedbackAnswer.Smiley else {
            return
        }
        
        setState(smilyAnswer.answer)
    }
    
    @IBAction private func veryPositiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .veryPositive)
    }
    @IBAction private func positiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .positive)
    }
    @IBAction private func negetiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .negetive)
    }
    @IBAction private func veryNegetiveWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .veryNegetive)
    }
    @IBAction private func neutralWasClicked(_ sender: UIButton) {
        resetState(button: sender, newState: .neutral)
    }
    
    private func getButtons() -> [UIButton] {
        return [veryPositiveFeedbackButton, positiveFeedbackButton, neutralFeedbackButton, negetiveFeedbackButton, veryNegetiveFeedbackButton]
    }
    
    private func resetState(button: UIButton, newState: FeedbackAnswer.Smiley.SmileyType) {
        // In case the user clicked on an already selected button, clear the selection
        if button.isSelected {
            resetAllButtons()
            return
        }
        
        setState(newState)
    }
    
    private func resetAllButtons() {
        for button in getButtons() {
            button.isSelected = false
            button.tintColor = feedbackAnswerColor
            button.imageView?.image = UIImage(named: "FeedbackRatingEmpty")?.withRenderingMode(.alwaysTemplate)
            if let unwrappedQuestion = question {
                delegate?.questionCleared(unwrappedQuestion)
            }
        }
    }
    
    private func setState(_ newState: FeedbackAnswer.Smiley.SmileyType) {
        let selectedButton = getButton(forState: newState)
        for button in getButtons() {
            let buttonIndex = getButtons().firstIndex(of: button)!
            let stateIndex = getButtons().firstIndex(of: selectedButton)!
            button.tintColor = feedbackAnswerColor
            button.isSelected = buttonIndex > stateIndex
        }
        

        let image = newState.getImage()
        selectedButton.setImage(image, for: .selected)
        selectedButton.isSelected = true
        selectedButton.tintColor = feedbackAnswerColor
        
        delegate?.questionWasAnswered(FeedbackAnswer.Smiley(questionText: question!.question, answer: newState))
    }
    
    private func getButton(forState: FeedbackAnswer.Smiley.SmileyType) -> UIButton {
        switch forState {
        case .veryNegetive:
            return veryNegetiveFeedbackButton
        case .negetive:
            return negetiveFeedbackButton
        case .neutral:
            return neutralFeedbackButton
        case .positive:
            return positiveFeedbackButton
        case .veryPositive:
            return veryPositiveFeedbackButton
        }
    }
}
