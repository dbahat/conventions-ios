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
    
    private let answerTextViewDefaultHeight = CGFloat(33)
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
        answerTextView.delegate = self
        
        // reset the height state during model binding
        cellHeightDelta = answerTextView.heightToFitContent() - answerTextViewDefaultHeight
    }
    
    override func setAnswer(answer: FeedbackAnswer) {
        answerTextView.text = answer.getAnswer()
        
        // resize the text view so it fits the text inside the answer
        var newFrame = answerTextView.frame
        newFrame.size = CGSize(width: answerTextView.frame.width, height: answerTextView.heightToFitContent())
        answerTextView.frame = newFrame;
        
        // re-calcuate the cell height delta, since it probebly changed due to the answer text
        cellHeightDelta = answerTextView.heightToFitContent() - answerTextViewDefaultHeight
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let newCellHeightDelta = answerTextView.heightToFitContent() - answerTextViewDefaultHeight
        
        // If the cell height delta changed, notify the calling table so it can re-size the cell (as cell
        // sizes in UITableView cannot "wrap content")
        if (cellHeightDelta != newCellHeightDelta) {
            cellHeightDelta = answerTextView.heightToFitContent() - answerTextViewDefaultHeight
            delegate?.questionViewHeightChanged(caller: self, newHeight: cellHeightDelta)
        }
        
        if (textView.text == "") {
            delegate?.questionCleared(question!)
            return
        }
        
        delegate?.questionWasAnswered(FeedbackAnswer.Text(questionText: question!.question, answer: textView.text))
    }
}
