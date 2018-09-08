//
//  SecondHandFormHeaderView.swift
//  Conventions
//
//  Created by David Bahat on 30/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

protocol SecondHandFormProtocol : class {
    func removeWasClicked(formId: Int)
}

class SecondHandFormHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var formIdLabel: UILabel!
    @IBOutlet private weak var formStatusLabel: UILabel!
    
    weak var delegate: SecondHandFormProtocol?
    
    var form: SecondHand.Form? {
        didSet {
            if let unwrapped = form {
                formIdLabel.text = "טופס מספר " + String(unwrapped.id)
                formStatusLabel.text = unwrapped.status.isClosed() ? "(סגור)" : ""
            
                formIdLabel.textColor = unwrapped.status.isClosed() ? Colors.secondHandClosedFormColor : Colors.secondHandOpenFormColor
                formStatusLabel.textColor = unwrapped.status.isClosed() ? Colors.secondHandClosedFormColor : Colors.secondHandOpenFormColor
            }
        }
    }
    
    @IBAction private func removeWasClicked(_ sender: UIButton) {
        if let unwrappedForm = form {
            delegate?.removeWasClicked(formId: unwrappedForm.id)
        }
    }
}
