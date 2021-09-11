//
//  ImportedTicketsViewController.swift
//  Conventions
//
//  Created by Bahat David on 11/09/2021.
//  Copyright © 2021 Amai. All rights reserved.
//

import Foundation

class ImportedTicketsViewController: UIViewController {
    @IBOutlet private var importedTickets: ImportedTicketsView!
    
    var topLabel: String?
    var bottomLabel: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        importedTickets.topLabel.text = topLabel
        importedTickets.bottomLabel.text = bottomLabel
        importedTickets.image.image = image
    }
}
