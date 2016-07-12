//
//  MultipleAnswerFeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/11/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class MultipleAnswerFeedbackQuestionCell : FeedbackQuestionCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MultipleAnswerCellProtocol {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var multipleAnswersCollectionView: UICollectionView!
    
    private var answersToSelectFrom: Array<String> = []
    private var selectedAnswer: String?
    
    override var enabled: Bool {
        didSet {
            multipleAnswersCollectionView.userInteractionEnabled = enabled
        }
    }
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
        
        multipleAnswersCollectionView.delegate = self
        multipleAnswersCollectionView.dataSource = self
        
        // Register the cell prototyle dynamiclly, since xcode doesn't allow defining prototyle cells in custom nibs
        multipleAnswersCollectionView.registerNib(UINib(nibName: String(MultipleAnswerCell), bundle: nil), forCellWithReuseIdentifier: String(MultipleAnswerCell))

        if let answersToSelectFrom = question.answersToSelectFrom {
            self.answersToSelectFrom = answersToSelectFrom
            multipleAnswersCollectionView.reloadData()
        }
    }
    
    override func setAnswer(answer: FeedbackAnswer) {
        selectedAnswer = answer.getAnswer()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answersToSelectFrom.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let answerToSelectFrom = answersToSelectFrom[indexPath.row]
        let cell = multipleAnswersCollectionView.dequeueReusableCellWithReuseIdentifier(String(MultipleAnswerCell), forIndexPath: indexPath) as! MultipleAnswerCell
        cell.answer = answerToSelectFrom
        cell.delegate = self
        cell.selected = answerToSelectFrom == selectedAnswer
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(60, 30)
    }
    
    func answerCellSelected(caller: MultipleAnswerCell) {
        guard let index = multipleAnswersCollectionView.indexPathForCell(caller) else {
            return
        }
        
        if caller.selected {
            selectedAnswer = nil
            delegate?.questionCleared(question!)
            multipleAnswersCollectionView.reloadData()
            return
        }
         
        let answer = answersToSelectFrom[index.row]
        selectedAnswer = answer
        delegate?.questionWasAnswered(FeedbackAnswer.Text(questionText: questionLabel.text!, answer: answer))
        multipleAnswersCollectionView.reloadData()
    }
}