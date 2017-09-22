//
//  AboutViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class AboutViewController : BaseViewController, UIWebViewDelegate {
    
    @IBOutlet fileprivate weak var aboutContentWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var aboutContentWebView: StaticContentWebView!
    @IBOutlet fileprivate weak var aboutAppVersionLabel: UILabel!
    @IBOutlet fileprivate weak var aboutAppContentLabel: UILabel!
    
    fileprivate let aboutAppContent = "האפליקציה פותחה על ידי דוד בהט וטל ספן עבור פסטיבל אייקון. בקשות והצעות ניתן לכתוב בדף האפליקציה בחנות. תודות: אלי בויום, אניטה קרפל, גיא בכר, גליה בהט, חננאל לבנה, תומר שלו."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        
        aboutContentWebView.setContent(aboutContent)
        aboutContentWebView.scrollView.isScrollEnabled = false
        aboutContentWebView.delegate = self
        
        aboutAppContentLabel.text = aboutAppContent
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            aboutAppVersionLabel.text = "גרסה " + version
        }
        
        navigationItem.title = "אודות הפסטיבל"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        aboutContentWebView.setContent(aboutContent)
        aboutAppContentLabel.text = aboutAppContent
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Reset the webView before calling sizeToFit(), which will only increase it's size
        webView.frame.size.height = 1.0
        webView.sizeToFit()
        
        aboutContentWebViewHeightConstraint.constant = aboutContentWebView.frame.size.height
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}
