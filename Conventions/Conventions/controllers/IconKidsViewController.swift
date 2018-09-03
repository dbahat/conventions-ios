//
//  IconKidsViewController.swift
//  Conventions
//
//  Created by Bahat, David on 03/09/2018.
//  Copyright © 2018 Amai. All rights reserved.
//

import Foundation

class IconKidsViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet private weak var contentWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        guard
            let resourcePath = Bundle.main.resourcePath,
            let webContent = try? String(contentsOfFile: resourcePath + "/IconKids.html") else {
            return
        }
        
        contentWebView.setContent(webContent)
        contentWebView.scrollView.isScrollEnabled = true
        contentWebView.delegate = self
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        
        return true
    }
}
