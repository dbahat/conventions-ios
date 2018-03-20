//
//  RadialGradientView.swift
//  Conventions
//
//  Created by David Bahat on 3/19/18.
//  Copyright © 2018 Amai. All rights reserved.
//

import Foundation

class RadialGradientView : UIView {
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var Transition: Double = 0.5 {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return RadialGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! RadialGradientLayer
        layer.colors = [ FirstColor.cgColor, SecondColor.cgColor ]
        layer.locations = [ CGFloat(Transition) ]
    }
}

// Needed since we abuse inheritance for adding attributes to the view, and we needed the radial gradient
// effect on both normal views and a UI table.
class RadialGradientTableView : UITableView {
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var Transition: Double = 0.5 {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return RadialGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! RadialGradientLayer
        layer.colors = [ FirstColor.cgColor, SecondColor.cgColor ]
        layer.locations = [ CGFloat(Transition) ]
    }
}
