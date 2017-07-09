//
//  DiscountsViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DiscountsViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet fileprivate weak var contentWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let resourcePath = Bundle.main.resourcePath,
            let aboutContent = try? String(contentsOfFile: resourcePath + "/DiscountsContent.html")
        else {
            return;
        }
        
        contentWebView.setContent(aboutContent)
        contentWebView.delegate = self
        
        navigationItem.title = "מבצעים והנחות"
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}
