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
    
    static let icon2023_red1 = UIColor(hexString: "#BA1200")
    static let icon2023_red2 = UIColor(hexString: "#D41206")
    static let icon2023_brown1 = UIColor(hexString: "#FFF6E5")
    static let icon2023_brown2 = UIColor(hexString: "#FFDEA1")
    static let icon2023_brown3 = UIColor(hexString: "#E4B177")
    static let icon2023_brown4 = UIColor(hexString: "#D29957")
    static let icon2023_brown5 = UIColor(hexString: "#B06C1E")
    static let icon2023_brown6 = UIColor(hexString: "#69401F")
    static let icon2023_brown7 = UIColor(hexString: "#251B0F")
    static let icon2023_brown8 = UIColor(hexString: "#67462B")
    static let icon2023_brown9 = UIColor(hexString: "#FCE9C4")
    
    static let icon2023_green1 = UIColor(hexString: "#45A355")
    static let icon2023_green2 = UIColor(hexString: "#0F621D")
    static let icon2023_green3 = UIColor(hexString: "#054810")
    static let icon2023_green4 = UIColor(hexString: "#407048")
    static let icon2023_green5 = UIColor(hexString: "#98D8A3")
    static let icon2023_blue1 = UIColor(hexString: "#2C3C5E")
    static let icon2023_blue2 = UIColor(hexString: "#3E536B")
    static let icon2023_blue3 = UIColor(hexString: "#103074")
    static let icon2023_blue4 = UIColor(hexString: "#4774D4")
    
    static let icon2023_gray1 = UIColor(hexString: "#E1E6E8")
    static let icon2023_gray2 = UIColor(hexString: "#79899C")
    static let icon2023_transparent_brown1 = UIColor(hexString: "#D8FFF6E5")

    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.icon2023_brown3
    static let tabBarSelectedTabColor = Colors.white
    static let tabBarUnselectedTabColor = Colors.icon2023_brown3
    static let textColor = UIColor.white
    static let backgroundColor = Colors.clear
    static let linksColor = Colors.icon2023_brown2
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.icon2023_brown1
    static let datePickerTextColor = Colors.black
    static let datePickerBackgroundColor = icon2023_transparent_brown1
    static let eventTimeDefaultBackgroundColor = Colors.olamot2023_green
    static let eventTimeHeaderColor = Colors.icon2023_brown6
    static let eventTimeHeaderTextColor = Colors.white
    static let buttonColor = Colors.icon2023_blue4
    static let logoffButtonColor = Colors.icon2023_red1
    static let buttonPressedColor = Colors.icon2023_blue2
    static let buttonDisabledColor = Colors.icon2023_gray1
    
    static let feedbackButtonPressedColor = Colors.icon2023_brown2
    
    static let feedbackButtonColorEvent = Colors.icon2023_brown2
    static let feedbackButtonColorConvetion = Colors.icon2023_brown2
    static let feedbackLinksColorEvent = Colors.olamot2023_yellow
    static let feedbackLinksColorConvention = Colors.olamot2023_red1
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.icon2023_brown2
    static let eventRunningColor = Colors.icon2023_brown5
    static let eventNotStartedColor = Colors.icon2023_brown3
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2023_brown5
    static let eventNotMarkedAsFavorite = Colors.icon2023_brown5
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = UIColor.clear
    static let eventTimeboxTextColor = Colors.icon2023_brown7
    static let eventTimeboxTextColorVirtual = Colors.olamot2023_pink1
    static let eventViewTitleAndDetailsContainerBackground = Colors.icon2023_brown1
    static let eventContentTextColor = Colors.icon2023_brown7
    
    // Event colors
    static let eventTitleBoxColor = Colors.clear
    static let eventDetailsBoxColor = Colors.icon2023_brown1
    static let eventTitleBackground = Colors.clear
    static let eventTitleBoarderColor = Colors.clear
    static let eventTitleTextColor = Colors.black
    static let eventSubTitleTextColor = Colors.icon2023_brown1
    static let eventFeedbackBoxColor = Colors.olamot2023_red1
    //static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    //static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = Colors.olamot2023_yellow
    static let eventDescriptionTextColor = Colors.black
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.eventEndedColor
    static let secondHandOpenFormColor = Colors.eventNotStartedColor
    
    // Home colors
    static let homeButtonsColor = Colors.icon2023_blue4
    static let homeButtonsTextColor = Colors.black
    static let homeCurrentEventColor = Colors.icon2023_brown1
    static let homeNextEventColor = Colors.icon2023_brown1
    static let homeTimeTextColor = Colors.icon2023_brown1
    static let homeTimeBoxContainerColor = Colors.icon2023_brown8
    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.black
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.icon2023_brown1
    static let homeCurrentEventHeadersBackgroundColor = Colors.icon2023_brown8
    static let homeUpcomingEventHeadersBackgroundColor = Colors.icon2023_brown2
    static let homeCurrentEventHeadersTextColor = Colors.icon2023_brown1
    static let homeUpcomingEventHeadersTextColor = Colors.black
    static let homeGoToMyEventsButtonTitleColor = Colors.icon2023_brown1

    
    // Updates colors
    static let updateTimeBackground = Colors.black
    static let updateTimeTextColor = Colors.olamot2023_pink2
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
