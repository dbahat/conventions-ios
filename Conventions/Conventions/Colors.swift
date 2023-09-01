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
    
    static let icon2023_red = UIColor(hexString: "6d2115")
    static let icon2023_brown1 = UIColor(hexString: "67462B")
    static let icon2023_brown2 = UIColor(hexString: "CEAA80")
    static let icon2023_brown3 = UIColor(hexString: "FCE9C4")
    static let icon2023_green1 = UIColor(hexString: "407049")
    static let icon2023_green2 = UIColor(hexString: "8fa371")
    static let icon2023_blue1 = UIColor(hexString: "2c3c5e")
    static let icon2023_blue2 = UIColor(hexString: "a3ab84")
    static let icon2023_blue3 = UIColor(hexString: "c6d0e0")

    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.icon2023_brown3
    static let tabBarSelectedTabColor = Colors.white
    static let tabBarUnselectedTabColor = Colors.icon2023_brown3
    static let textColor = UIColor.white
    static let backgroundColor = UIColor.clear
    static let linksColor = Colors.icon2023_brown3
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.icon2023_brown1
    static let eventTimeDefaultBackgroundColor = Colors.olamot2023_green
    static let eventTimeHeaderColor = Colors.icon2023_brown1
    static let eventTimeHeaderTextColor = Colors.icon2023_brown3
    static let buttonColor = Colors.olamot2023_red1
    static let buttonPressedColor = Colors.olamot2023_red2
    static let buttonDisabledColor = Colors.olamot2023_brown1
    
    static let feedbackButtonPressedColor = Colors.olamot2023_yellow
    
    static let feedbackButtonColorEvent = Colors.black
    static let feedbackButtonColorConvetion = Colors.black
    static let feedbackLinksColorEvent = Colors.olamot2023_yellow
    static let feedbackLinksColorConvention = Colors.olamot2023_red1
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.black
    static let eventRunningColor = Colors.black
    static let eventNotStartedColor = Colors.black
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2023_green1
    static let eventNotMarkedAsFavorite = Colors.icon2023_green2
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = UIColor.clear
    static let eventTimeboxColor = Colors.icon2023_brown2
    static let eventTimeboxColorVirtual = Colors.olamot2023_red2
    static let eventTimeboxTextColor = Colors.black
    static let eventTimeboxTextColorVirtual = Colors.olamot2023_pink1
    static let eventViewTitleAndDetailsContainerBackground = Colors.icon2023_brown3
    
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
    static let homeButtonsColor = Colors.icon2023_blue1
    static let homeButtonsTextColor = Colors.black
    static let homeCurrentEventColor = Colors.icon2023_brown3
    static let homeNextEventColor = Colors.icon2023_brown2
    static let homeTimeTextColor = Colors.icon2023_brown3
    static let homeTimeBoxContainerColor = Colors.icon2023_red
    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.icon2023_red
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.icon2023_brown3
    static let homeEventHeadersBackgroundColor = Colors.icon2023_brown1
    static let homeEventHeadersTextColor = Colors.icon2023_brown3
    static let homeGoToMyEventsButtonTitleColor = Colors.white

    
    // Updates colors
    static let updateTimeBackground = Colors.black
    static let updateTimeTextColor = Colors.olamot2023_pink2
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
