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
    
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var contentContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var container: RoundedView!
    @IBOutlet private weak var sendFeedbackLabel: UILabel!
    @IBOutlet private weak var thanksForComingLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        inflateNib(AfterConventionHomeContentView.self)
        titleContainer.backgroundColor = Colors.clear
        contentContainer.backgroundColor = Colors.buttonColor
        titleLabel.textColor = Colors.textColor
        thanksForComingLabel.textColor = Colors.textColor
        sendFeedbackLabel.textColor = Colors.homeFirstButtonTextColor
        
        contentContainer.layer.cornerRadius = 4
        
        container.layer.borderWidth = 0
        container.layer.borderColor = Colors.black.cgColor
    }
    
    @IBAction func sendFeedbackButtonWasClicked(_ sender: Any) {
        delegate?.navigateToFeedbackClicked()
    }
}
