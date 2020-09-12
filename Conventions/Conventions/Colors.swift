//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {    
    
    static let icon2020_blue = UIColor(hexString: "#0A125B")
    static let icon2020_teal = UIColor(hexString: "#6AB1C3")
    static let icon2020_beige = UIColor(hexString: "#DDE9CC")
    static let icon2020_red = UIColor(hexString: "#DD2428")
    static let icon2020_dark_red = UIColor(hexString: "#7F171F")
    static let icon2020_green = UIColor(hexString: "#7EA39F")
    
    static let colorAccent = Colors.icon2020_red
    static let textColor = UIColor.black
    static let backgroundColor = Colors.icon2020_green
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.icon2020_dark_red
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.icon2020_red

    static let buttonPressedColor = Colors.icon2020_dark_red
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.icon2020_beige
    static let eventRunningColor = Colors.icon2020_blue
    static let eventNotStartedColor = UIColor.black
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2020_red
    static let eventNotMarkedAsFavorite = Colors.icon2020_dark_red
    static let eventSeperatorColor = UIColor.black
    
    // Event colors
    static let eventDetailsBoxColor = Colors.icon2020_beige
    static let eventTitleBackground = Colors.icon2020_dark_red
    static let eventTitleBoarderColor = Colors.icon2020_dark_red
    static let eventTitleTextColor = UIColor.white
    static let eventDetailsHighlightedTextColor = UIColor.white
    static let eventFeedbackBoxColor = Colors.icon2020_dark_red
    static let eventFeedbackButtonsColor = UIColor.white
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = Colors.icon2020_blue
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.buttonColor
    static let homeButtonsTextColor = UIColor.white
    static let homeCurrentEventColor = Colors.icon2020_red
    static let homeNextEventColor = Colors.icon2020_beige
    static let homeTimeTextColor = UIColor.white
    static let homeMainLabelTextColor = UIColor.black
    static let homeTimeBoxContainerColor = Colors.icon2020_dark_red
    
    // Updates colors
    static let updateTimeBackground = Colors.icon2020_dark_red
    static let updateTimeTextColor = UIColor.white
    
    // Map colors
    static let mapIndicatorColor = Colors.icon2020_blue
    static let mapIndicatorSelectedColor = Colors.icon2020_blue
}
