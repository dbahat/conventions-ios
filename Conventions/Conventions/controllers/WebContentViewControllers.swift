//
//  IconKidsViewController.swift
//  Conventions
//
//  Created by Bahat, David on 03/09/2018.
//  Copyright © 2018 Amai. All rights reserved.
//

import Foundation

class WebContentViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet private weak var contentWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        guard
            let resourcePath = Bundle.main.resourcePath,
            let webContent = try? String(contentsOfFile: resourcePath + getWebPageName()) else {
                return
        }
        
        contentWebView.setContent(webContent)
        contentWebView.scrollView.isScrollEnabled = true
        contentWebView.delegate = self
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == UIWebView.NavigationType.linkClicked {
            UIApplication.shared.open(request.url!, options: [:]) { (success) in }
            return false
        }
        
        return true
    }
    
    func getWebPageName() -> String {
        return ""
    }
}

class IconKidsViewController: WebContentViewController {
    override func getWebPageName() -> String {
        return "/IconKids.html"
    }
}

class DiscountsViewController: WebContentViewController {
    override func getWebPageName() -> String {
        return "/DiscountsContent.html"
    }
}

class AccessabilityViewController: WebContentViewController {
    override func getWebPageName() -> String {
        return "/AccessabilityContent.html"
    }
}
