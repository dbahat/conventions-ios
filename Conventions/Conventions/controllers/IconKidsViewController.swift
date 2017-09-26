//
//  IconKidsViewController.swift
//  Conventions
//
//  Created by David Bahat on 26/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation
import SafariServices

class IconKidsViewController: BaseViewController {
    private let iconKidsUrl = URL(string: "http://www.cinema.co.il/news/new.aspx?0r9VQ=MHD")!
    
    override func viewDidLoad() {
        navigationItem.title = "אייקון Kids"
    }
    
    @IBAction func openIconKidsWebsiteWasClicked(_ sender: UIButton) {
        GAI.sharedInstance().defaultTracker.send(
            GAIDictionaryBuilder.createEvent(
                withCategory: "IconKids",
                action: "OpenWebsiteClicked",
                label: "",
                value:  0).build() as! [AnyHashable : Any]!)
        
        if #available(iOS 9.0, *) {
            present(SFSafariViewController(url: iconKidsUrl), animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(iconKidsUrl)
        }
    }
}
