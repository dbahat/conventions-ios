//
//  DiscountsCell.swift
//  Conventions
//
//  Created by Bahat David on 29/09/2022.
//  Copyright © 2022 Amai. All rights reserved.
//

import Foundation

class DiscountCell : UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var link: UIButton!
    var linkUrl: URL?
    @IBOutlet weak var linkHeightConstraint: NSLayoutConstraint!
    
    @IBAction func onLinkClicked(_ sender: UIButton) {
        if let url = linkUrl {
            UIApplication.shared.open(url)
        }
    }
}
