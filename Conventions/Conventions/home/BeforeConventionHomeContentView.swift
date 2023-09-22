//
//  BeforeConventionHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 16/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class BeforeConventionHomeContentView : UIView {
    @IBOutlet private weak var conventionDatesLabel: UILabel!
    @IBOutlet private weak var remainingDaysLabel: UILabel!
    @IBOutlet private weak var timeBoxContainer: UIView!
    @IBOutlet private weak var mainContentContainer: UIView!
    @IBOutlet private weak var updatesButtonContainer: UIButton!
    @IBOutlet private weak var container: RoundedView!
    @IBOutlet private weak var eventsButtonContainer: UIButton!
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        inflateNib(BeforeConventionHomeContentView.self)
        
        eventsButtonContainer.backgroundColor = Colors.homeFirstButtonColor
        updatesButtonContainer.backgroundColor = Colors.homeSecondButtonColor
        mainContentContainer.backgroundColor = Colors.clear
        timeBoxContainer.backgroundColor = Colors.clear
        remainingDaysLabel.textColor = Colors.textColor
        conventionDatesLabel.textColor = Colors.textColor
        eventsButtonContainer.setTitleColor(Colors.homeFirstButtonTextColor, for: .normal)
        updatesButtonContainer.setTitleColor(Colors.homeSecondButtonTextColor, for: .normal)
        
        eventsButtonContainer.layer.cornerRadius = 4
        updatesButtonContainer.layer.cornerRadius = 4
        
        container.layer.borderWidth = 0
        container.layer.borderColor = Colors.textColor.cgColor
    }
    
    func setDates(start: Date, end: Date) {
        conventionDatesLabel.text = String(format: "%@ - %@", start.format("dd.MM.yyyy"), end.format("dd.MM.yyyy"))
        if let numberOfDays = Calendar.current.dateComponents(
            [.day],
            from: Date.now().clearTimeComponent(),
            to:start).day {
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
