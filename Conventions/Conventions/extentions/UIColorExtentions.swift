//
//  UIColorExtentions.swift
//  Conventions
//
//  Created by David Bahat on 2/12/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString:String) {
        self.init(hexString: hexString, alpha: 1)
    }
    
    convenience init(hexString:String, alpha:Double) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    var hexString: String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            let multiplier = CGFloat(255.999999)

            guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return ""
            }

            if alpha == 1.0 {
                return String(
                    format: "#%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier)
                )
            }
            else {
                return String(
                    format: "#%02lX%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier),
                    Int(alpha * multiplier)
                )
            }
        }
}
