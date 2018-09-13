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
    @IBOutlet private weak var priceLabel: UILabel!
    
    func bind(item: SecondHand.Item, isFormClosed: Bool) {
        titleLabel.text = formatDescription(item: item).stringByDecodingHTMLEntities + " (" + item.category.text + ")"
        statusLabel.text = item.status.text
        
        let textColor = isFormClosed ? Colors.secondHandClosedFormColor : Colors.secondHandOpenFormColor
        titleLabel.textColor = textColor
        statusLabel.textColor = textColor
        idLabel.textColor = textColor
        priceLabel.textColor = textColor
        
        priceLabel.text = String.init(format: "%d ש״ח", item.price)
        idLabel.text = String.init(format: "%03d/%02d", item.formId, item.indexInForm)
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
        return item.description.isEmpty ? "פריט " + String(item.indexInForm) : item.description
    }
    
    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
}
