//
//  DiscountsViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class DiscountsViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet private weak var contentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resourcePath = NSBundle.mainBundle().resourcePath else {
            return;
        };
        
        guard let aboutContent = try? String(contentsOfFile: resourcePath + "/DiscountsContent.html") else {
            return;
        }
        
        contentWebView.loadHTMLString(String(format: "<body style=\"font: -apple-system-body\"><div dir='rtl'>%@</div></body>", aboutContent), baseURL: nil)
        contentWebView.delegate = self
        
        navigationItem.title = "מבצעים והנחות"
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
