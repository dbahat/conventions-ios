//
//  AfterConventionHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 17/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class AfterConventionHomeContentView : UIView {
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inflateNib(AfterConventionHomeContentView.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inflateNib(AfterConventionHomeContentView.self)
    }
    
    @IBAction func sendFeedbackButtonWasClicked(_ sender: Any) {
        delegate?.navigateToFeedbackClicked()
    }
}
