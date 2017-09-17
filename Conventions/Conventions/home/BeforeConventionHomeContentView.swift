//
//  BeforeConventionHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 16/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

protocol ConventionHomeContentViewProtocol : class {
    func navigateToEventsClicked()
    func navigateToUpdatesClicked()
}

class BeforeConventionHomeContentView : UIView {
    @IBOutlet private weak var conventionDatesLabel: UILabel!
    @IBOutlet private weak var remainingDaysLabel: UILabel!
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed(String(describing: BeforeConventionHomeContentView.self), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = Bundle.main.loadNibNamed(String(describing: BeforeConventionHomeContentView.self), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    func setDates(start: Date, end: Date) {
        conventionDatesLabel.text = String(format: "%@ - %@", start.format("dd.MM.yyyy"), end.format("dd.MM.yyyy"))
        if let numberOfDays = Calendar.current.dateComponents([.day], from: Date.now(), to: start).day {
            remainingDaysLabel.text = formatRemainingDays(numberOfDays)
        }
    }
    
    @IBAction private func navigateToUpdatesWasCliced(_ sender: UIButton) {
        delegate?.navigateToUpdatesClicked()
    }
    
    @IBAction private func navigateToEventsWasClicked(_ sender: UIButton) {
        delegate?.navigateToEventsClicked()
    }
    
    private func formatRemainingDays(_ remainingDays: Int) -> String {
        switch remainingDays {
        case 1:
            return "מחר!"
        case 2:
            return "עוד יומיים!"
        default:
            return String(format: "עוד %d ימים!", remainingDays)
        }
    }
}
