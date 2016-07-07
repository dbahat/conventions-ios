//
//  UITextView.swift
//  Conventions
//
//  Created by David Bahat on 7/8/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

extension UITextView {
    func heightToFitContent() -> CGFloat {
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        return newSize.height
    }
}