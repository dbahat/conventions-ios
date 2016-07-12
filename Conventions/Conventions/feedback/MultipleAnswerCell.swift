//
//  MultipleAnswerCell.swift
//  Conventions
//
//  Created by David Bahat on 7/11/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol MultipleAnswerCellProtocol : class {
    func answerCellSelected(caller: MultipleAnswerCell)
}

class MultipleAnswerCell : UICollectionViewCell {
    
    @IBOutlet private weak var answerButton: UIButton!
    
    var delegate: MultipleAnswerCellProtocol?
    
    var answer: String? {
        didSet {
            answerButton.setTitle(answer, forState: UIControlState.Normal)
            answerButton.setTitle(answer, forState: UIControlState.Selected)
        }
    }
    
    override var selected: Bool {
        didSet {
            answerButton.selected = selected
        }
    }
    
    @IBAction private func answerSelected(sender: UIButton) {
        delegate?.answerCellSelected(self)
    }
}