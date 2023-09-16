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
    
    private let aboutAppContent = "האפליקציה פותחה על ידי דוד בהט וטל ספן עבור פסטיבל אייקון. בקשות והצעות ניתן לכתוב בדף האפליקציה בחנות. תודות: איתמר ריינר, אלי בויום, גליה בהט, מיה שראל."
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        
        abountContentTextView.attributedText = aboutContent.htmlAttributedString()
        
        aboutAppContentLabel.text = aboutAppContent
        aboutAppContentLabel.textColor = Colors.textColor
        aboutAppTitleLabel.textColor = Colors.textColor
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            aboutAppVersionLabel.text = "גרסה " + version
            aboutAppVersionLabel.textColor = Colors.textColor
        }
        
        navigationItem.title = "אודות הכנס"
    }
}
