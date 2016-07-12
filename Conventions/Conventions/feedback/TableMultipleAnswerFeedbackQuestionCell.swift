//
//  TableMultipleAnswerQuestionCell.swift
//  Conventions
//
//  Created by David Bahat on 7/13/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class TableMultipleAnswerFeedbackQuestionCell : FeedbackQuestionCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionsTableView: UITableView!
    
    private var answersToSelectFrom: Array<String> = []
    private var selectedAnswerIndex: NSIndexPath?
    
    private let cellHeight = CGFloat(44)
    
    override var enabled: Bool {
        didSet {
            questionsTableView.userInteractionEnabled = enabled
        }
    }
    
    override func questionDidSet(question: FeedbackQuestion) {
        questionLabel.text = question.question
        
        questionsTableView.registerNib(UINib(nibName: String(TableAnswerCell), bundle: nil), forCellReuseIdentifier: String(TableAnswerCell))
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        
        cellHeightDelta = cellHeight * CGFloat(question.answersToSelectFrom?.count ?? 0)
        
        if let answersToSelectFrom = question.answersToSelectFrom {
            self.answersToSelectFrom = answersToSelectFrom
            questionsTableView.reloadData()
        }
    }
    
    override func setAnswer(answer: FeedbackAnswer) {
        if let answerIndex = answersToSelectFrom.indexOf({$0 == answer.getAnswer()}) {
            selectedAnswerIndex = NSIndexPath(forRow: answerIndex, inSection: 0)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersToSelectFrom.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let answerToSelectFrom = answersToSelectFrom[indexPath.row]
        let cell = questionsTableView.dequeueReusableCellWithIdentifier(String(TableAnswerCell)) as! TableAnswerCell;
        cell.answer = answerToSelectFrom
        cell.selected = indexPath == selectedAnswerIndex
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedAnswerIndex == indexPath {
            selectedAnswerIndex = nil
            delegate?.questionCleared(question!)
        } else {
            selectedAnswerIndex = indexPath
            delegate?.questionWasAnswered(FeedbackAnswer(questionText: question!.question))
        }
        questionsTableView.reloadData()
    }
}