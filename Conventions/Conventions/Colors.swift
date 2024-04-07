//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
        
    static let olamot2024_blue50 = UIColor(hexString: "#F0FDFF")
    static let olamot2024_blue50_transparent_80 = UIColor(hexString: "#F0FDFF",alpha: 0.8)
    static let olamot2024_blue50_transparent_90 = UIColor(hexString: "#F0FDFF",alpha: 0.9)
    static let olamot2024_blue100 = UIColor(hexString: "#D6FAFF")
    static let olamot2024_blue200 = UIColor(hexString: "#B6EBF3")
    static let olamot2024_blue300 = UIColor(hexString: "#94DCE7")
    static let olamot2024_blue500 = UIColor(hexString: "#5AAEBB")
    static let olamot2024_blue600 = UIColor(hexString: "#348895")
    static let olamot2024_blue700 = UIColor(hexString: "#1A727F")
    static let olamot2024_blue700_transparent_50 = UIColor(hexString: "#1A727F", alpha: 0.5)
    static let olamot2024_blue900 = UIColor(hexString: "#08353C")

    static let olamot2024_pink50 = UIColor(hexString: "#FFF5F6")
    static let olamot2024_pink50_transparent_80 = UIColor(hexString: "#FFF5F6", alpha: 0.8)
    static let olamot2024_pink100 = UIColor(hexString: "#FFE5E7")
    static let olamot2024_pink200 = UIColor(hexString: "#FAD0D3")
    static let olamot2024_pink300 = UIColor(hexString: "#E7B2B6")
    static let olamot2024_pink400 = UIColor(hexString: "#E6A3AB")
    static let olamot2024_pink600 = UIColor(hexString: "#B45069")
    static let olamot2024_pink700 = UIColor(hexString: "#871A40")
    static let olamot2024_pink900 = UIColor(hexString: "#4A061E")

    static let olamot2024_gray1 = UIColor(hexString: "#E1E6E8")
    static let olamot2024_gray3 = UIColor(hexString: "#A3B5BC")
    static let olamot2024_gold = UIColor(hexString: "#E8B247")
    static let olamot2024_red1 = UIColor(hexString: "#D41206")
    static let olamot2024_green1 = UIColor(hexString: "#99C95E")
    static let olamot2024_black = UIColor(hexString: "#303030")
    
    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.olamot2024_blue900
    static let tabBarSelectedTabColor = Colors.olamot2024_pink700
    static let tabBarUnselectedTabColor = Colors.black
    static let tabBarBackgroundColor = Colors.olamot2024_pink50_transparent_80
    static let textColor = Colors.olamot2024_blue900
    static let hintTextColor = Colors.olamot2024_blue700
    static let backgroundColor = Colors.clear
    static let linksColor = Colors.olamot2024_blue700
    static let highlightedTextColor = Colors.olamot2024_blue100
    
    static let navigationBarBackgroundColor = Colors.olamot2024_pink600
    static let navigationBarTextColor = Colors.olamot2024_pink50
    
    static let switchButtonsColor = Colors.colorAccent
    static let datePickerColor = Colors.olamot2024_pink200
    static let datePickerTextColor = Colors.olamot2024_pink700
    static let datePickerBackgroundColor = Colors.olamot2024_pink50
    static let eventTimeDefaultBackgroundColor = Colors.olamot2024_pink200
    static let eventTimeHeaderColor = Colors.olamot2024_blue700_transparent_50
    static let eventTimeHeaderTextColor = Colors.olamot2024_blue900
    static let buttonColor = Colors.olamot2024_blue700
    static let logoffButtonColor = Colors.olamot2024_red1
    static let buttonPressedColor = Colors.olamot2024_blue300
    static let buttonDisabledColor = Colors.olamot2024_gray3
    
    static let feedbackButtonColor = Colors.buttonColor
    static let feedbackButtonPressedColor = Colors.buttonPressedColor
    
    static let feedbackButtonColorEvent = Colors.buttonColor
    static let feedbackButtonColorConvetion = Colors.olamot2024_gold
    static let feedbackLinksColorEvent = Colors.linksColor
    static let feedbackLinksColorConvention = Colors.linksColor
    static let expandFeedbackButtonColor = Colors.olamot2024_blue700
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventEndedColor = Colors.olamot2024_pink200
    static let eventRunningColor = Colors.olamot2024_pink600
    static let eventNotStartedColor = Colors.olamot2024_pink300
    static let eventRunningTimeTextColor = Colors.white
    static let eventNotRunningTimeTextColor = Colors.olamot2024_pink900
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.olamot2024_pink700
    static let eventMarkedAsFavorite = Colors.olamot2024_gold
    static let eventNotMarkedAsFavorite = Colors.olamot2024_gold
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = UIColor.clear
    static let eventTimeboxTextColor = Colors.eventContentTextColor
    static let eventTimeboxTextColorVirtual = Colors.eventTimeboxTextColor
    static let eventViewTitleAndDetailsContainerBackground = Colors.olamot2024_pink50
    static let eventContentTextColor = Colors.olamot2024_pink900
    
    // Event colors
    static let eventTitleBoxColor = Colors.clear
    static let eventDetailsBoxColor = Colors.olamot2024_pink50
    static let eventTitleBackground = Colors.clear
    static let eventTitleBoarderColor = Colors.clear
    static let eventTitleTextColor = Colors.olamot2024_pink900
    static let eventSubTitleTextColor = Colors.olamot2024_pink900
    static let eventFeedbackBoxColor = Colors.olamot2024_blue50_transparent_80
    static let eventFeedbackTextColor = Colors.olamot2024_blue700
    static let eventDescriptionTextColor = Colors.black
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.eventEndedColor
    static let secondHandOpenFormColor = Colors.eventNotStartedColor
    
    // Home colors
    static let homeFirstButtonColor = Colors.olamot2024_pink900
    static let homeSecondButtonColor = Colors.olamot2024_pink900
    static let homeFirstButtonTextColor = Colors.olamot2024_blue100
    static let homeSecondButtonTextColor = Colors.olamot2024_blue900
    static let homeCurrentEventColor = Colors.olamot2024_pink50_transparent_80
    static let homeNextEventColor = Colors.olamot2024_pink50_transparent_80
    static let homeTimeTextColor = Colors.olamot2024_pink50
    static let homeTimeBoxContainerColor = Colors.olamot2024_pink600
    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.olamot2024_pink900
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.olamot2024_pink50_transparent_80
    static let homeCurrentEventHeadersBackgroundColor = Colors.olamot2024_pink600
    static let homeUpcomingEventHeadersBackgroundColor = Colors.olamot2024_pink400
    static let homeCurrentEventHeadersTextColor = Colors.olamot2024_pink50
    static let homeUpcomingEventHeadersTextColor = Colors.olamot2024_pink900
    static let homeGoToMyEventsButtonColor = Colors.olamot2024_blue600
    static let homeGoToMyEventsButtonTitleColor = Colors.olamot2024_blue100
    static let homeTextColor = Colors.olamot2024_blue700

    
    // Updates colors
    static let updateTimeBackground = Colors.clear
    static let updateTimeTextColor = Colors.olamot2024_blue900
    static let updateTextColor = Colors.olamot2024_pink900
    static let updateBackgroundColor = Colors.olamot2024_pink50_transparent_80
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
}
