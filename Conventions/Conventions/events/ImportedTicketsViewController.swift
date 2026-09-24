//
//  ImportedTicketsViewController.swift
//  Conventions
//
//  Created by Bahat David on 11/09/2021.
//  Copyright © 2021 Amai. All rights reserved.
//

import Foundation

class ImportedTicketsViewController: UIViewController {
    @IBOutlet var importedTickets: ImportedTicketsView!
    
    var topLabel: String?
    var midLabel: String?
    var bottomLabel: String?
    var image: UIImage?
    var onLogoutClicked: (() -> Void)?
    var onRefreshClicked: (() -> Void)?
    var shouldHideUpdatesButtonImage = false
    
    var originalBrightness = UIScreen.main.brightness
    
    override func viewDidLoad() {
        importedTickets.topLabel.text = topLabel
        importedTickets.midLabel.text = midLabel
        importedTickets.bottomLabel.text = bottomLabel
        importedTickets.image.image = image
        importedTickets.onLogoutClicked = onLogoutClicked
        importedTickets.onRefreshClicked = onRefreshClicked
        importedTickets.updatesButtonImage.isHidden = shouldHideUpdatesButtonImage
        importedTickets.onBrightnessClicked = { (isOn: Bool) -> Void in
            if isOn {
                UIScreen.main.brightness = 1
            } else {
                UIScreen.main.brightness = self.originalBrightness
            }
        }

        // Show the QR at maximal brightness so convention scanners can read it more easily
        UIScreen.main.brightness = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIScreen.main.brightness = self.originalBrightness
    }
}
