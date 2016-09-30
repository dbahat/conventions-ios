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
        // Removing the below CSS attribute since it seem to cause texts to be left aligned
        let rightAlignedContent = content.replace(pattern: "white-space: pre-wrap;", withTemplate: "")
        
        // Change the font, disable re-size during orientation change and align the text to the right
        loadHTMLString(String(format: "<body style=\"font: -apple-system-body\"><div dir='rtl' style='-webkit-text-size-adjust: none;'>%@</div></body>", rightAlignedContent ?? ""), baseURL: nil)
    }
}
