//
//  AboutView.swift
//  Conventions
//
//  Created by David Bahat on 9/13/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    let attributedContent: NSAttributedString

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Image("AboutLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 10)

                    AboutHTMLContentView(attributedText: attributedContent)
                        .padding(.horizontal, 16)
                        .background(Color(uiColor: Colors.staticHtmlContentColor))
                        .cornerRadius(4)
                }
                .padding(16)
            }
        }
    }
}

private struct AboutHTMLContentView: UIViewRepresentable {
    let attributedText: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .clear
        textView.attributedText = attributedText
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }
}
