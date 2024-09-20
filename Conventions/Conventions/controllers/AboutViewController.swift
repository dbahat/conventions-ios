//
//  AboutViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class AboutViewController : BaseViewController {
    
    @IBOutlet private weak var aboutAppVersionLabel: UILabel!
    @IBOutlet private weak var aboutAppContentLabel: UILabel!
    @IBOutlet private weak var aboutAppTitleLabel: UILabel!
    @IBOutlet private weak var abountContentTextView: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        
        abountContentTextView.attributedText = aboutContent.htmlAttributedString()
        abountContentTextView.backgroundColor = Colors.icon2024_cream50
        abountContentTextView.layer.cornerRadius = 4
        
        navigationItem.title = "אודות הכנס"
    }
}
