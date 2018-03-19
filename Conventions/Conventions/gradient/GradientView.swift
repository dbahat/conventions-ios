//
//  GradientView.swift
//  Conventions
//
//  Created by David Bahat on 3/18/18.
//  Copyright © 2018 Amai. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIButton {

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
    
    @IBInspectable var ThirdColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var FirstTransition: Double = 0.5 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var SecondTransition: Double = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var Angle: Float = 180 {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = ThirdColor == UIColor.clear
            ? [ FirstColor.cgColor, SecondColor.cgColor ]
            : [ FirstColor.cgColor, SecondColor.cgColor, ThirdColor.cgColor ]
        layer.locations = SecondTransition == 0
            ? [ NSNumber(value: FirstTransition) ]
            : [ NSNumber(value: FirstTransition), NSNumber(value: SecondTransition) ]
        
        let alpha: Float = Angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        layer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        layer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
    }
}
