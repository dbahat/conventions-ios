//
//  MultipleAnswerFeedbackQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/11/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class MultipleAnswerFeedbackQuestionCell : FeedbackQuestionCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MultipleAnswerCellProtocol {
    
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var multipleAnswersCollectionView: UICollectionView!
    
    fileprivate var answersToSelectFrom: Array<String> = []
    fileprivate var selectedAnswer: String?
    
    override var enabled: Bool {
        didSet {
            multipleAnswersCollectionView.isUserInteractionEnabled = enabled
        }
    }
    
    override func questionDidSet(_ question: FeedbackQuestion) {
        questionLabel.text = question.question
        
        multipleAnswersCollectionView.delegate = self
        multipleAnswersCollectionView.dataSource = self
        
        // Register the cell prototyle dynamiclly, since xcode doesn't allow defining prototyle cells in custom nibs
        multipleAnswersCollectionView.register(UINib(nibName: String(describing: MultipleAnswerCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MultipleAnswerCell.self))

        if let answersToSelectFrom = question.answersToSelectFrom {
            self.answersToSelectFrom = answersToSelectFrom
            multipleAnswersCollectionView.reloadData()
        }
    }
    
    override func setAnswer(_ answer: FeedbackAnswer) {
        selectedAnswer = answer.getAnswer()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answersToSelectFrom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let answerToSelectFrom = answersToSelectFrom[indexPath.row]
        let cell = multipleAnswersCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MultipleAnswerCell.self), for: indexPath) as! MultipleAnswerCell
        cell.answer = answerToSelectFrom
        cell.delegate = self
        cell.isSelected = answerToSelectFrom == selectedAnswer
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 30)
    }
    
    func answerCellSelected(_ caller: MultipleAnswerCell) {
        guard let index = multipleAnswersCollectionView.indexPath(for: caller) else {
            return
        }
        
        if caller.isSelected {
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
