//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    static let black = UIColor(hexString: "#000F18")
    static let darkRed = UIColor(hexString: "#8D3347")
    static let semiTransperentRed = UIColor(hexString: "#350213", alpha: 0.5)
    static let teal = UIColor(hexString: "#88FCF9")
    
    static let colorAccent = Colors.darkRed
    static let eventTimeDefaultBackgroundColor = Colors.darkRed
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = UIColor.white
    static let buttonPressedColor = UIColor(hexString: "#41937d")
    static let eventEndedColor = UIColor(hexString: "#FFFFFF", alpha: 0.4)
    static let eventRunningColor = Colors.teal
    static let eventNotStartedColor = UIColor.white
    static let eventUserNeedsToCompleteFeecbackButtonColor = UIColor(hexString: "#ffca58")
    static let eventMarkedAsFavorite = UIColor(hexString: "#ffca58")
    static let eventDetailsHighlightedTextColor = UIColor(hexString: "#FEFFC9")
    static let eventFeedbackBoxColor = Colors.semiTransperentRed
    
    static let secondHandClosedFormColor = UIColor(hexString: "#D2D3D5")
    static let secondHandOpenFormColor = UIColor.white
    
}
