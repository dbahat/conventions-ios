//
//  UIViewExtentions.swift
//  Conventions
//
//  Created by David Bahat on 18/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

extension UIView {
    // Inflates the nib file into the custom view as a subview.
    func inflateNib<T>(_ type:  T) {
        let view = Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
