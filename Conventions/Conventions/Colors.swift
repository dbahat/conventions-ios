//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let olamot2022_brown1 = UIColor(hexString: "#210400")
    static let olamot2022_brown2 = UIColor(hexString: "#4e463c")
    static let olamot2022_brown3 = UIColor(hexString: "#776654")
    static let olamot2022_brown4 = UIColor(hexString: "#998d78")
    static let olamot2022_yellow1 = UIColor(hexString: "#9f735b")
    static let olamot2022_yellow2 = UIColor(hexString: "#ed9928")
    static let olamot2022_yellow3 = UIColor(hexString: "#cdbb7b")
    static let olamot2022_rust = UIColor(hexString: "#9b3f38")
    static let black = UIColor.black
    static let white = UIColor.white
    
    static let colorAccent = Colors.olamot2022_rust
    static let tabBarSelectedTabColor = Colors.olamot2022_rust
    static let tabBarUnselectedTabColor = Colors.black
    static let textColor = UIColor.black
    static let backgroundColor = UIColor.clear
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.olamot2022_brown2
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.olamot2022_rust
    static let buttonPressedColor = Colors.olamot2022_brown4
    
    static let feedbackButtonPressedColor = Colors.olamot2022_rust
    
    static let feedbackButtonColorEvent = Colors.olamot2022_yellow2
    static let feedbackButtonColorConvetion = Colors.olamot2022_yellow2
    static let feedbackLinksColorEvent = Colors.feedbackButtonColorEvent
    static let feedbackLinksColorConvention = Colors.feedbackButtonColorConvetion
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.olamot2022_brown2
    static let eventRunningColor = Colors.olamot2022_rust
    static let eventNotStartedColor = Colors.black
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.olamot2022_rust
    static let eventNotMarkedAsFavorite = Colors.olamot2022_brown2
    static let eventSeperatorColor = UIColor.black
    static let eventOpenEventConatinerColor = Colors.olamot2022_yellow3
    static let eventTimeboxColorVirtual = Colors.olamot2022_yellow1
    static let eventTimeboxTextColor = Colors.white
    static let eventTimeboxTextColorVirtual = Colors.black
    
    // Event colors
    static let eventDetailsBoxColor = UIColor.clear
    static let eventTitleBackground = Colors.olamot2022_brown1
    static let eventTitleBoarderColor = Colors.olamot2022_rust
    static let eventTitleTextColor = UIColor.white
    static let eventDetailsHighlightedTextColor = Colors.olamot2022_rust
    static let eventFeedbackBoxColor = Colors.olamot2022_brown2
    //static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    //static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = UIColor.clear
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.olamot2022_yellow1
    static let homeButtonsTextColor = UIColor.black
    static let homeCurrentEventColor = Colors.olamot2022_brown2
    static let homeNextEventColor = Colors.olamot2022_brown1
    static let homeTimeTextColor = UIColor.white
    static let homeMainLabelTextColor = UIColor.white
    static let homeTimeBoxContainerColor = Colors.olamot2022_rust
    
    // Updates colors
    static let updateTimeBackground = Colors.olamot2022_rust
    static let updateTimeTextColor = Colors.white
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
