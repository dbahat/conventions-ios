//
//  TextFeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class TextFeedbackQuestionCell: FeedbackQuestionCell, UITextViewDelegate  {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answerTextView: UITextView!
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
        answerTextView.delegate = self
    }
    
    func textViewDidChange(textView: UITextView) {
        if (textView.text == "") {
            delegate?.questionCleared(question!)
            return
        }
        
        delegate?.questionWasAnswered(FeedbackAnswer.Text(questionText: question!.question, answer: textView.text))
    }
}
