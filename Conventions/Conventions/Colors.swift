//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {    
    
    static let icon2019_blue = UIColor(hexString: "#1C1868")
    static let icon2019_violet1 = UIColor(hexString: "#574ACE")
    static let icon2019_violet2 = UIColor(hexString: "#8543ff")
    static let icon2019_pink1 = UIColor(hexString: "#D643FF")
    static let icon2019_pink2 = UIColor(hexString: "#fcd6e5")
    static let icon2019_cyan1 = UIColor(hexString: "#69B2f9")
    static let icon2019_cyan2 = UIColor(hexString: "#A1E2ff")

    
    static let colorAccent = Colors.icon2019_pink1
    static let textColor = UIColor.black
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.icon2019_violet2
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.icon2019_violet2

    static let buttonPressedColor = Colors.icon2019_pink2
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.icon2019_violet1
    static let eventRunningColor = Colors.icon2019_pink2
    static let eventNotStartedColor = UIColor.black
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2019_pink2
    static let eventNotMarkedAsFavorite = Colors.icon2019_violet1
    static let eventSeperatorColor = UIColor.black
    
    // Event colors
    static let eventDetailsBoxColor = Colors.icon2019_pink2
    static let eventTitleBackground = Colors.icon2019_cyan1
    static let eventTitleBoarderColor = Colors.icon2019_blue
    static let eventDetailsHighlightedTextColor = UIColor.white
    static let eventFeedbackBoxColor = Colors.icon2019_pink1
    static let eventFeedbackButtonsColor = UIColor.white
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = Colors.icon2019_violet1
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.icon2019_violet2
    static let homeButtonsTextColor = UIColor.white
    static let homeCurrentEventColor = Colors.icon2019_cyan2
    static let homeNextEventColor = Colors.icon2019_violet1
    static let homeTimeTextColor = UIColor.black
    static let homeMainLabelTextColor = UIColor.white
    static let homeTimeBoxContainerColor = Colors.icon2019_pink2
    
    // Updates colors
    static let updateTimeBackground = Colors.icon2019_violet2
    static let updateTimeTextColor = UIColor.white
    
    // Map colors
    static let mapIndicatorColor = Colors.icon2019_violet1
    static let mapIndicatorSelectedColor = Colors.icon2019_pink2
}
