//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {    
    static let olamot2019_blue = UIColor(hexString: "#1B75BB")
    static let olamot2019_grey1 = UIColor(hexString: "#231F20")
    static let olamot2019_grey2 = UIColor(hexString: "#6A6B6C")
    static let olamot2019_yellow1 = UIColor(hexString: "#D3A150")
    static let olamot2019_yellow2 = UIColor(hexString: "#EEC060")
    static let olamot2019_yellow3 = UIColor(hexString: "#F0CB8B")
    static let olamot2019_yellow4 = UIColor(hexString: "#FAE4BF")
    static let olamot2019_brown1 = UIColor(hexString: "#965744")
    static let olamot2019_brown2 = UIColor(hexString: "#A25C4A")
    static let olamot2019_brown3 = UIColor(hexString: "#B2684C")
    static let olamot2019_brown4 = UIColor(hexString: "#D5987E")
    static let olamot2019_yellow5 = UIColor(hexString: "#fff5e3")
    static let olamot2019_blue2 = UIColor(hexString: "#259BF7")
    
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
    static let eventTimeDefaultBackgroundColor = Colors.olamot2019_yellow1
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.icon2019_violet2

    static let buttonPressedColor = Colors.icon2019_pink1
    static let mapBackgroundColor = Colors.olamot2019_yellow5
    
    // Events colors
    static let eventEndedColor = Colors.olamot2019_grey2
    static let eventRunningColor = Colors.olamot2019_blue
    static let eventNotStartedColor = UIColor.black
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.olamot2019_blue
    static let eventNotMarkedAsFavorite = Colors.olamot2019_brown4
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
    static let secondHandClosedFormColor = Colors.olamot2019_grey2
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
    static let updateTimeBackground = Colors.olamot2019_yellow1
}
