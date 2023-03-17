//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let olamot2023_yellow = UIColor(hexString: "#f0cc92")
    static let olamot2023_green = UIColor(hexString: "#9d9855")
    static let olamot2023_red1 = UIColor(hexString: "#902b13")
    static let olamot2023_red2 = UIColor(hexString: "#442017")
    static let olamot2023_brown1 = UIColor(hexString: "#a87246")
    static let olamot2023_brown2 = UIColor(hexString: "#63332C")
    static let olamot2023_pink1 = UIColor(hexString: "#d8a388")
    static let olamot2023_pink2 = UIColor(hexString: "#d18f6d")
    static let olamot2023_pink2_transperent = UIColor(hexString: "#D8D18F6D")
    
    static let icon2022_green1 = UIColor(hexString: "#9eea51")
    
    static let black = UIColor.black
    static let white = UIColor.white
    
    static let colorAccent = Colors.olamot2023_red1
    static let tabBarSelectedTabColor = Colors.buttonPressedColor
    static let tabBarUnselectedTabColor = Colors.buttonColor
    static let textColor = UIColor.black
    static let backgroundColor = UIColor.clear
    static let linksColor = Colors.olamot2023_red1
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.olamot2023_red1
    static let eventTimeDefaultBackgroundColor = Colors.icon2022_green1
    static let eventTimeHeaderColor = Colors.olamot2023_red1
    static let eventTimeHeaderTextColor = Colors.white
    static let buttonColor = Colors.olamot2023_brown1
    static let buttonPressedColor = Colors.olamot2023_brown2
    
    static let feedbackButtonPressedColor = Colors.olamot2023_yellow
    
    static let feedbackButtonColorEvent = Colors.black
    static let feedbackButtonColorConvetion = Colors.black
    static let feedbackLinksColorEvent = Colors.olamot2023_yellow
    static let feedbackLinksColorConvention = Colors.olamot2023_yellow
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.olamot2023_brown2
    static let eventRunningColor = Colors.black
    static let eventNotStartedColor = Colors.olamot2023_red1
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.olamot2023_red1
    static let eventNotMarkedAsFavorite = Colors.olamot2023_brown1
    static let eventSeperatorColor = Colors.olamot2023_red1
    static let eventOpenEventConatinerColor = UIColor.clear
    static let eventTimeboxColor = Colors.olamot2023_red2
    static let eventTimeboxColorVirtual = Colors.olamot2023_red2
    static let eventTimeboxTextColor = Colors.olamot2023_pink1
    static let eventTimeboxTextColorVirtual = Colors.olamot2023_pink1
    
    // Event colors
    static let eventDetailsBoxColor = Colors.olamot2023_yellow
    static let eventTitleBackground = Colors.black
    static let eventTitleBoarderColor = Colors.black
    static let eventTitleTextColor = Colors.olamot2023_yellow
    static let eventFeedbackBoxColor = Colors.olamot2023_red1
    //static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    //static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = Colors.olamot2023_yellow
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.eventEndedColor
    static let secondHandOpenFormColor = Colors.eventNotStartedColor
    
    // Home colors
    static let homeButtonsColor = Colors.buttonColor
    static let homeButtonsTextColor = UIColor.black
    static let homeCurrentEventColor = Colors.olamot2023_green
    static let homeNextEventColor = Colors.olamot2023_yellow
    static let homeTimeTextColor = Colors.olamot2023_yellow
    static let homeMainLabelTextColor = Colors.olamot2023_yellow
    static let homeTimeBoxContainerColor = Colors.black
    
    // Updates colors
    static let updateTimeBackground = Colors.black
    static let updateTimeTextColor = Colors.olamot2023_pink2
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
