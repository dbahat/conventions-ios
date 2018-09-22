//
//  MoreInfoViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

// Using UITableViewController since we want this tableView to have static cells
class MoreInfoViewController : UITableViewController {

    @IBOutlet private weak var settingsImage: UIImageView!
    @IBOutlet private weak var aboutImage: UIImageView!
    @IBOutlet private weak var arrivalMethodsImage: UIImageView!
    @IBOutlet private weak var feedbackImage: UIImageView!
    @IBOutlet private weak var updatesImage: UIImageView!
    @IBOutlet private weak var IconKidsImage: UIImageView!
    @IBOutlet private weak var secondHandImage: UIImageView!
    @IBOutlet private weak var discountdImage: UIImageView!
    
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var settingsLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var arrivalMethodsLabel: UILabel!
    @IBOutlet private weak var updatesLabel: UILabel!
    @IBOutlet private weak var iconKidsLabel: UILabel!
    @IBOutlet private weak var secondHandLabel: UILabel!
    @IBOutlet private weak var discountsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
        
        let imageView = UIImageView(image: UIImage(named: "AppBackground"))
        imageView.contentMode = .scaleAspectFill
        tableView?.backgroundView = imageView
        
        adjustImageView(settingsImage)
        adjustImageView(aboutImage)
        adjustImageView(feedbackImage)
        adjustImageView(arrivalMethodsImage)
        adjustImageView(updatesImage)
        adjustImageView(IconKidsImage)
        adjustImageView(secondHandImage)
        adjustImageView(discountdImage)
        
        feedbackLabel.textColor = Colors.textColor
        settingsLabel.textColor = Colors.textColor
        aboutLabel.textColor = Colors.textColor
        arrivalMethodsLabel.textColor = Colors.textColor
        updatesLabel.textColor = Colors.textColor
        iconKidsLabel.textColor = Colors.textColor
        secondHandLabel.textColor = Colors.textColor
        discountsLabel.textColor = Colors.textColor
    }
    
    private func adjustImageView(_ imageView: UIImageView) {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.textColor
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Hide the feedback menu if not yet relevant
        if indexPath.row == 0 && !Convention.instance.canFillConventionFeedback() {
            return 0
        }
        
        return 44
    }
}
