//
//  StringExtentions.swift
//  Conventions
//
//  Created by Bahat David on 10/09/2022.
//  Copyright © 2022 Amai. All rights reserved.
//

import Foundation

extension String {
    func htmlAttributedString(color: UIColor = UIColor.white) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: 14px;
                color: \(color.hexString);
                line-height: 1.4;
              }
            </style>
          </head>
          <body>
            <div dir='rtl' style='-webkit-text-size-adjust: none;'>
                \(self)
            </div>
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
}
