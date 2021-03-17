//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let olamot2021_red1 = UIColor(hexString: "#2C0000")
    static let olamot2021_red2 = UIColor(hexString: "#710101")
    static let olamot2021_red3 = UIColor(hexString: "#9E2214")
    static let olamot2021_grey1 = UIColor(hexString: "#D5D5D5")
    static let olamot2021_grey2 = UIColor(hexString: "#707070")
    static let olamot2021_grey3 = UIColor(hexString: "#3F3E39")
    static let olamot2021_yellow1 = UIColor(hexString: "#F49519")
    static let olamot2021_yellow2 = UIColor(hexString: "#FBB03B")
    
    static let colorAccent = Colors.olamot2021_yellow2
    static let tabBarSelectedTabColor = Colors.olamot2021_red2
    static let textColor = UIColor.white
    static let backgroundColor = UIColor.clear
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.colorAccent
    static let eventTimeDefaultBackgroundColor = Colors.olamot2021_grey3
    static let eventTimeHeaderColor = UIColor.clear
    static let buttonColor = Colors.olamot2021_yellow2
    static let buttonPressedColor = Colors.olamot2021_yellow1
    
    static let feedbackButtonColor = Colors.olamot2021_grey1
    static let feedbackButtonPressedColor = Colors.buttonColor
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.olamot2021_grey1
    static let eventRunningColor = Colors.olamot2021_yellow2
    static let eventNotStartedColor = UIColor.white
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.eventMarkedAsFavorite
    static let eventMarkedAsFavorite = Colors.olamot2021_yellow2
    static let eventNotMarkedAsFavorite = UIColor.white
    static let eventSeperatorColor = UIColor.black
    static let eventOpenEventConatinerColor = Colors.olamot2021_grey2
    
    // Event colors
    static let eventDetailsBoxColor = Colors.olamot2021_red2
    static let eventTitleBackground = Colors.olamot2021_grey3
    static let eventTitleBoarderColor = UIColor.white
    static let eventTitleTextColor = UIColor.white
    static let eventDetailsHighlightedTextColor = UIColor.white
    static let eventFeedbackBoxColor = Colors.olamot2021_grey3
    static let eventFeedbackButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackAnswersButtonsColor = Colors.feedbackButtonColor
    static let eventFeedbackTextColor = UIColor.white
    
    // SecondHand colors
    static let secondHandClosedFormColor = UIColor.clear
    static let secondHandOpenFormColor = UIColor.black
    
    // Home colors
    static let homeButtonsColor = Colors.buttonColor
    static let homeButtonsTextColor = UIColor.white
    static let homeCurrentEventColor = Colors.olamot2021_grey2
    static let homeNextEventColor = Colors.olamot2021_grey1
    static let homeTimeTextColor = UIColor.white
    static let homeMainLabelTextColor = UIColor.black
    static let homeTimeBoxContainerColor = Colors.olamot2021_grey3
    
    // Updates colors
    static let updateTimeBackground = Colors.olamot2021_grey3
    static let updateTimeTextColor = UIColor.white
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
