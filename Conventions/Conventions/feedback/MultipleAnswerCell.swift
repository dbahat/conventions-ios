//
//  MultipleAnswerCell.swift
//  Conventions
//
//  Created by David Bahat on 7/11/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol MultipleAnswerCellProtocol : class {
    func answerCellSelected(_ caller: MultipleAnswerCell)
}

class MultipleAnswerCell : UICollectionViewCell {
    
    @IBOutlet fileprivate weak var answerButton: UIButton!
    
    weak var delegate: MultipleAnswerCellProtocol?
    
    var answer: String? {
        didSet {
            answerButton.setTitle(answer, for: UIControlState())
            answerButton.setTitle(answer, for: UIControlState.selected)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            answerButton.isSelected = isSelected
        }
    }
    
    @IBAction fileprivate func answerSelected(_ sender: UIButton) {
        delegate?.answerCellSelected(self)
    }
}
