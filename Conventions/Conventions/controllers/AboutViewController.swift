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
    
    private let aboutAppContent = "האפליקציה פותחה על ידי דוד בהט וטל ספן עבור פסטיבל אייקון. בקשות והצעות ניתן לכתוב בדף האפליקציה בחנות. <br/>תודות: גליה בהט, דמיאן הופמן, חננאל לבנה, עמרי רוזנברג, תומר שלו."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return
        }
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        
        aboutContentWebView.setContent(aboutContent)
        aboutContentWebView.scrollView.scrollEnabled = false
        aboutContentWebView.delegate = self
        
        aboutAppContentWebView.setContent(aboutAppContent)
        aboutAppContentWebView.scrollView.scrollEnabled = false
        aboutAppContentWebView.delegate = self
        
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            aboutAppVersionLabel.text = "גרסה " + version
        }
        
        navigationItem.title = "אודות הפסטיבל"
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return
        }
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html") else {
            return
        }
        aboutContentWebView.setContent(aboutContent)
        aboutAppContentWebView.setContent(aboutAppContent)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // Reset the webView before calling sizeToFit(), which will only increase it's size
        webView.frame.size.height = 1.0
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
