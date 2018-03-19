//
//  RadialGradientLayer.swift
//  Conventions
//
//  Created by David Bahat on 3/19/18.
//  Copyright © 2018 Amai. All rights reserved.
//

import Foundation

class RadialGradientLayer : CALayer {
    required override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(layer: Any) {
        super.init(layer: layer)
    }
    
    var colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
    var locations: [CGFloat] = [0.5]
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = max(bounds.width, bounds.height)
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
