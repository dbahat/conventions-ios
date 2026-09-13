//
//  AboutViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import SwiftUI

class AboutViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "אודות הכנס"

        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        guard
            let resourcePath = Bundle.main.resourcePath,
            let aboutContent = try? String(contentsOfFile: resourcePath + "/AboutContent.html"),
            let attributedContent = aboutContent.htmlAttributedString()
        else {
            return
        }

        embedSwiftUIView(AboutView(attributedContent: attributedContent))
    }
}
