//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let icon2021_blue1 = UIColor(hexString: "#1c4a9f")
    static let icon2021_blue2 = UIColor(hexString: "#2ca7cb")
    static let icon2021_blue3 = UIColor(hexString: "#82cbde")
    static let icon2021_yellow1 = UIColor(hexString: "#945b00")
    static let icon2021_yellow2 = UIColor(hexString: "#ed9928")
    static let icon2021_yellow3 = UIColor(hexString: "#e7b865")
    static let black = UIColor.black
    static let white = UIColor.white
    
    static let colorAccent = Colors.icon2021_yellow1
    static let tabBarSelectedTabColor = Colors.buttonPressedColor
    static let textColor = UIColor.black
    static let backgroundColor = UIColor.clear
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.icon2021_yellow1
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.icon2021_yellow2
    static let buttonPressedColor = Colors.icon2021_yellow3
    
    static let feedbackButtonPressedColor = Colors.icon2021_blue2
    
    static let feedbackButtonColorEvent = Colors.icon2021_yellow3
    static let feedbackButtonColorConvetion = Colors.icon2021_yellow1
    static let feedbackLinksColorEvent = Colors.feedbackButtonColorEvent
    static let feedbackLinksColorConvention = Colors.feedbackButtonColorConvetion
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.icon2021_blue2
    static let eventRunningColor = Colors.icon2021_blue1
    static let eventNotStartedColor = Colors.icon2021_yellow1
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.icon2021_blue1
    static let eventNotMarkedAsFavorite = Colors.icon2021_yellow1
    static let eventSeperatorColor = UIColor.black
    static let eventOpenEventConatinerColor = Colors.icon2021_yellow1
    static let eventTimeboxColorVirtual = Colors.icon2021_yellow3
    static let eventTimeboxTextColor = Colors.white
    static let eventTimeboxTextColorVirtual = Colors.black
    
    // Event colors
    static let eventDetailsBoxColor = Colors.icon2021_yellow3
    static let eventTitleBackground = Colors.icon2021_blue1
    static let eventTitleBoarderColor = UIColor.clear
    static let eventTitleTextColor = UIColor.white
    static let eventDetailsHighlightedTextColor = UIColor.white
    static let eventFeedbackBoxColor = Colors.icon2021_blue1
    //static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    //static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = UIColor.clear
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.buttonColor
    static let homeButtonsTextColor = UIColor.white
    static let homeCurrentEventColor = Colors.icon2021_yellow2
    static let homeNextEventColor = Colors.icon2021_yellow3
    static let homeTimeTextColor = UIColor.white
    static let homeMainLabelTextColor = UIColor.black
    static let homeTimeBoxContainerColor = Colors.icon2021_blue1
    
    // Updates colors
    static let updateTimeBackground = Colors.icon2021_blue1
    static let updateTimeTextColor = UIColor.white
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
