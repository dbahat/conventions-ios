//
//  AboutViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class AboutViewController : BaseViewController, UIWebViewDelegate {
    
    @IBOutlet private weak var aboutContentWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var aboutAppContentWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var aboutContentWebView: StaticContentWebView!
    @IBOutlet private weak var aboutAppVersionLabel: UILabel!
    @IBOutlet private weak var aboutAppContentWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return;
        }
        
        aboutContentWebView.setContent(aboutContent)
        aboutContentWebView.scrollView.scrollEnabled = false
        aboutContentWebView.delegate = self
        
        let aboutAppContent = "האפליקציה פותחה על ידי דוד בהט וטל ספן עבור פסטיבל אייקון. בקשות והצעות ניתן לכתוב <a href=\"market://details?id=sff.org.conventions/\">בדף האפליקציה בחנות</a>. <br/>תודות: גליה בהט, דמיאן הופמן, חננאל לבנה, תומר שלו."
        aboutAppContentWebView.setContent(aboutAppContent)
        aboutAppContentWebView.scrollView.scrollEnabled = false
        aboutAppContentWebView.delegate = self
        
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            aboutAppVersionLabel.text = "גרסה " + version
        }
        
        navigationItem.title = "אודות הפסטיבל"
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.sizeToFit()
        
        aboutContentWebViewHeightConstraint.constant = aboutContentWebView.frame.size.height
        aboutAppContentWebViewHeightConstraint.constant = aboutAppContentWebView.frame.size.height
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
