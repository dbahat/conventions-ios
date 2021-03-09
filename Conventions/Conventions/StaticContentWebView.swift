//
//  ContentWrappingWebView.swift
//  Conventions
//
//  Created by David Bahat on 9/30/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class StaticContentWebView : UIWebView {
 
    func setContent(_ content: String) {
        setContent(content, color: "#ffffff")
    }
    
    func setContent(_ content: String, color: String) {
        // Removing the below CSS attribute since it seem to cause texts to be left aligned
        let rightAlignedContent = content.replace(pattern: "white-space: pre-wrap;", withTemplate: "")
        
        // Remove all hardcoded color attributes in the text
        let colorlessContent = rightAlignedContent?.replace(pattern: "color:", withTemplate: "")
                
        // Change the font, disable re-size during orientation change and align the text to the right
        loadHTMLString(String(format: "<body style=\"font: -apple-system-body; color:"+color+"\"><div dir='rtl' style='-webkit-text-size-adjust: none; font-size: 14px;'>%@</div></body>", colorlessContent ?? ""), baseURL: Bundle.main.bundleURL)
    }
}
