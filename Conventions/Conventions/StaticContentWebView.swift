//
//  ContentWrappingWebView.swift
//  Conventions
//
//  Created by David Bahat on 9/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class StaticContentWebView : UIWebView {
 
    func setContent(content: String) {
        let rightAlignedContent = content.replace(pattern: "white-space: pre-wrap;", withTemplate: "")
        loadHTMLString(String(format: "<body style=\"font: -apple-system-body\"><div dir='rtl' style='-webkit-text-size-adjust: none;'>%@</div></body>", rightAlignedContent ?? ""), baseURL: nil)
    }
}
