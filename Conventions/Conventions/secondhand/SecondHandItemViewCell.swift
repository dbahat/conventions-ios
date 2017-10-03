//
//  SecondHandItemViewCell.swift
//  Conventions
//
//  Created by David Bahat on 30/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class SecondHandItemViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    func bind(item: SecondHand.Item, isFormClosed: Bool) {
        titleLabel.text = formatDescription(item: item) + formatType(item.type)
        statusLabel.text = formatStatus(item.status)
        titleLabel.textColor = isFormClosed ? Colors.secondHandClosedFormColor : Colors.secondHandOpenFormColor
        idLabel.text = item.id
    }
    
    // Mark the cell with a clear color mask
    func maskCell(fromTop margin: CGFloat) {
        layer.mask = visibilityMask(withLocation: margin / frame.size.height)
        layer.masksToBounds = true
    }
    
    private func formatType(_ type: String) -> String {
        return type.isEmpty ? "" : " (" + type + ")"
    }
    
    private func formatDescription(item: SecondHand.Item) -> String {
        return item.description.isEmpty ? "פריט " + String(item.number ?? 1) : item.description
    }
    
    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
    
    private func formatStatus(_ status: SecondHand.Item.Status) -> String {
        switch status {
        case .sold:
            return "נמכר"
        case .missing:
            return "חסר"
        default:
            return "לא נמכר"
        }
    }
}
