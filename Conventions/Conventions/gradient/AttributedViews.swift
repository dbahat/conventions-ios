//
//  AttributedViews.swift
//  Conventions
//
//  Created by David Bahat on 3/20/18.
//  Copyright © 2018 Amai. All rights reserved.
//

import Foundation

@IBDesignable
class ShadowedView : UIView {
    @IBInspectable var ShadowColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var ShadowOpacity: Float = 0.5 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var ShadowOffsetWidth: Int = 1 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var ShadowOffsetHeight: Int = 1 {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        layer.shadowColor = ShadowColor.cgColor
        layer.shadowOpacity = ShadowOpacity
        layer.shadowOffset = CGSize(width: ShadowOffsetWidth, height: ShadowOffsetHeight)        
    }
}

@IBDesignable
class RoundedView: UIView {
    @IBInspectable var Radius: Float = 0.0 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        layer.cornerRadius = CGFloat(Radius)
        layer.masksToBounds = true
    }
}
