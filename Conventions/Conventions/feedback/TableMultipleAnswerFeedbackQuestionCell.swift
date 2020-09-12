//
//  TableMultipleAnswerQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class TableMultipleAnswerFeedbackQuestionCell : FeedbackQuestionCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var questionsTableView: UITableView!
    
    fileprivate var answersToSelectFrom: Array<String> = []
    fileprivate var selectedAnswerIndex: IndexPath?
    
    fileprivate let cellHeight = CGFloat(44)
    
    override var enabled: Bool {
        didSet {
            questionsTableView.isUserInteractionEnabled = enabled
        }
    }
    
    override func questionDidSet(_ question: FeedbackQuestion) {
        questionLabel.text = question.question
        questionLabel.textColor = feedbackTextColor
        
        questionsTableView.register(UINib(nibName: String(describing: TableAnswerCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableAnswerCell.self))
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        
        cellHeightDelta = cellHeight * CGFloat(question.answersToSelectFrom?.count ?? 0)
        
        if let answersToSelectFrom = question.answersToSelectFrom {
            self.answersToSelectFrom = answersToSelectFrom
            questionsTableView.reloadData()
        }
    }
    
    override func setAnswer(_ answer: FeedbackAnswer) {
        if let answerIndex = answersToSelectFrom.firstIndex(where: {$0 == answer.getAnswer()}) {
            selectedAnswerIndex = IndexPath(row: answerIndex, section: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersToSelectFrom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answerToSelectFrom = answersToSelectFrom[indexPath.row]
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: String(describing: TableAnswerCell.self)) as! TableAnswerCell;
        cell.answer = answerToSelectFrom
        cell.isSelected = indexPath == selectedAnswerIndex
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedAnswerIndex == indexPath {
            selectedAnswerIndex = nil
            delegate?.questionCleared(question!)
        } else {
            selectedAnswerIndex = indexPath
            delegate?.questionWasAnswered(FeedbackAnswer.Text(questionText: question!.question, answer: answersToSelectFrom[indexPath.row]))
        }
        questionsTableView.reloadData()
    }
}
