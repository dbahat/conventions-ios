//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let icon2022_green1 = UIColor(hexString: "#9eea51")
    static let icon2022_green2 = UIColor(hexString: "#86bf43")
    static let icon2022_red1 = UIColor(hexString: "#ff3333")
    static let icon2022_red2 = UIColor(hexString: "#a82222")
    static let icon2022_gray1 = UIColor(hexString: "#2b2928")
    static let icon2022_gray2 = UIColor(hexString: "#969493")
    static let icon2022_gray3 = UIColor(hexString: "#e9e4e0")
    
    static let black = UIColor.black
    static let white = UIColor.white
    
    static let colorAccent = Colors.icon2022_red1
    static let tabBarSelectedTabColor = Colors.icon2022_green1
    static let tabBarUnselectedTabColor = Colors.icon2022_gray3
    static let textColor = UIColor.white
    static let backgroundColor = UIColor.clear
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.icon2022_green1
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.icon2022_red1
    static let buttonPressedColor = Colors.icon2022_red2
    
    static let feedbackButtonPressedColor = Colors.icon2022_green1
    
    static let feedbackButtonColorEvent = Colors.icon2022_red1
    static let feedbackButtonColorConvetion = Colors.icon2022_red1
    static let feedbackLinksColorEvent = Colors.feedbackButtonColorEvent
    static let feedbackLinksColorConvention = Colors.feedbackButtonColorConvetion
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.icon2022_gray2
    static let eventRunningColor = Colors.icon2022_green1
    static let eventNotStartedColor = Colors.icon2022_gray3
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2022_red1
    static let eventNotMarkedAsFavorite = Colors.icon2022_gray3
    static let eventSeperatorColor = UIColor.black
    static let eventOpenEventConatinerColor = Colors.icon2022_gray3
    static let eventTimeboxColorVirtual = Colors.icon2022_gray1
    static let eventTimeboxTextColor = Colors.white
    static let eventTimeboxTextColorVirtual = Colors.black
    
    // Event colors
    static let eventDetailsBoxColor = UIColor.clear
    static let eventTitleBackground = Colors.icon2022_green1
    static let eventTitleBoarderColor = Colors.icon2022_green1
    static let eventTitleTextColor = UIColor.black
    static let eventDetailsHighlightedTextColor = Colors.icon2022_red2
    static let eventFeedbackBoxColor = Colors.icon2022_gray2
    //static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    //static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = UIColor.clear
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.icon2022_red1
    static let homeButtonsTextColor = UIColor.black
    static let homeCurrentEventColor = UIColor.clear
    static let homeNextEventColor = UIColor.clear
    static let homeTimeTextColor = UIColor.white
    static let homeMainLabelTextColor = UIColor.white
    static let homeTimeBoxContainerColor = Colors.icon2022_gray2
    
    // Updates colors
    static let updateTimeBackground = Colors.icon2022_gray1
    static let updateTimeTextColor = Colors.white
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
