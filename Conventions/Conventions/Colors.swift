//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
        
    static let icon2024_blue50 = UIColor(hexString: "#D6ECFF")
    static let icon2024_blue100 = UIColor(hexString: "#ADD2F3")
    static let icon2024_blue200 = UIColor(hexString: "#8EBBE3")
    static let icon2024_blue300 = UIColor(hexString: "#6FA5D5")
    static let icon2024_blue600 = UIColor(hexString: "#2F70AA")
    static let icon2024_blue600_transparent_50 = UIColor(hexString: "#2F70AA", alpha: 0.5)
    static let icon2024_blue900 = UIColor(hexString: "#0C3B66")

    static let icon2024_clay50 = UIColor(hexString: "#FCEAE3")
    static let icon2024_clay100 = UIColor(hexString: "#F5CCBC")
    static let icon2024_clay200 = UIColor(hexString: "#ECAE97")
    static let icon2024_clay300 = UIColor(hexString: "#E59375")
    static let icon2024_clay400 = UIColor(hexString: "#D27654")
    static let icon2024_clay600 = UIColor(hexString: "#B54C25")
    static let icon2024_clay700 = UIColor(hexString: "#AB411A")
    static let icon2024_clay900 = UIColor(hexString: "#7E2505")

    static let icon2024_gray200 = UIColor(hexString: "#E1D7D3")
    static let icon2024_gray300 = UIColor(hexString: "#CCC3C0")
    static let icon2024_gray700 = UIColor(hexString: "#706763")
    static let icon2024_gray800 = UIColor(hexString: "#554D49")
    static let icon2024_gray900 = UIColor(hexString: "#352E2A")

    static let icon2024_cream50 = UIColor(hexString: "#FFF9F0")
    static let icon2024_cream50_transparent_90 = UIColor(hexString: "#FFF9F0", alpha: 0.9)
    static let icon2024_cream200 = UIColor(hexString: "#FEEAC6")
    static let icon2024_cream400 = UIColor(hexString: "#F4CE8C")
    static let icon2024_cream500 = UIColor(hexString: "#EBBF72")
    static let icon2024_cream600 = UIColor(hexString: "#E8B04E")
    static let icon2024_cream700 = UIColor(hexString: "#DDA034")
    static let icon2024_cream1000 = UIColor(hexString: "#7E5204")

    static let icon2024_green600 = UIColor(hexString: "#839669")

    static let icon2024_gold = UIColor(hexString: "#F0CF64")
    static let icon2024_red = UIColor(hexString: "#D41206")
    
    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.icon2024_blue900
    static let tabBarSelectedTabColor = Colors.icon2024_cream50
    static let tabBarUnselectedTabColor = Colors.icon2024_cream400
    static let tabBarBackgroundColor = Colors.icon2024_blue600
    static let textColor = Colors.icon2024_gray800
    static let hintTextColor = Colors.icon2024_gray700
    static let backgroundColor = Colors.clear
    static let linksColor = Colors.icon2024_blue600
    
    static let navigationBarBackgroundColor = Colors.clear
    static let navigationBarTextColor = Colors.icon2024_gray800
    
    static let switchButtonsColor = Colors.icon2024_cream1000
    static let datePickerColor = Colors.icon2024_cream500
    static let datePickerTextColor = Colors.textColor
    static let datePickerBackgroundColor = Colors.icon2024_cream50
    static let eventTimeDefaultBackgroundColor = Colors.icon2024_clay200
    static let eventTimeHeaderColor = Colors.icon2024_cream500
    static let eventTimeHeaderTextColor = Colors.icon2024_cream1000
    static let buttonColor = Colors.icon2024_blue600
    static let logoffButtonColor = Colors.icon2024_cream1000
    static let buttonPressedColor = Colors.icon2024_blue300
    static let buttonDisabledColor = Colors.icon2024_blue600_transparent_50
    
    static let feedbackButtonColor = Colors.buttonColor
    static let feedbackButtonPressedColor = Colors.buttonPressedColor
    
    static let feedbackButtonColorEvent = Colors.buttonColor
    static let feedbackButtonColorConvetion = Colors.icon2024_cream700
    static let feedbackLinksColorEvent = Colors.linksColor
    static let feedbackLinksColorConvention = Colors.linksColor
    static let expandFeedbackButtonColor = Colors.icon2024_blue600
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventSearchBarTextColor = Colors.icon2024_clay900
    static let eventEndedColor = Colors.icon2024_blue100
    static let eventRunningColor = Colors.icon2024_blue600
    static let eventNotStartedColor = Colors.icon2024_blue200
    static let eventRunningTimeTextColor = Colors.white
    static let eventNotRunningTimeTextColor = Colors.icon2024_blue900
    static let eventUserNeedsToCompleteFeecbackButtonColor = Colors.icon2024_cream700
    static let eventMarkedAsFavorite = Colors.icon2024_cream700
    static let eventNotMarkedAsFavorite = Colors.icon2024_gray200
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = UIColor.clear
    static let eventTimeboxTextColor = Colors.eventContentTextColor
    static let eventTimeboxTextColorVirtual = Colors.eventTimeboxTextColor
    static let eventViewTitleAndDetailsContainerBackground = Colors.icon2024_cream50_transparent_90
    static let eventContentTextColor = Colors.icon2024_cream1000
    static let eventFeedbackIconSentColor = Colors.icon2024_green600
    
    // Event colors
    static let eventTitleBoxColor = Colors.clear
    static let eventDetailsBoxColor = Colors.icon2024_cream50
    static let eventTitleBackground = Colors.clear
    static let eventTitleBoarderColor = Colors.clear
    static let eventTitleTextColor = Colors.white
    static let eventSubTitleTextColor = Colors.textColor
    static let eventFeedbackBoxColor = Colors.icon2024_blue100
    static let eventFeedbackTextColor = Colors.icon2024_blue900
    static let eventDescriptionTextColor = Colors.black
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.icon2024_gray700
    static let secondHandOpenFormColor = Colors.icon2024_cream1000
    static let secondHandHeaderBackgroundColor = Colors.icon2024_cream200
    
    // Home colors
    static let homeFirstButtonColor = Colors.icon2024_clay700
    static let homeSecondButtonColor = Colors.icon2024_clay200
    static let homeFirstButtonTextColor = Colors.white
    static let homeSecondButtonTextColor = Colors.icon2024_clay900
    static let homeCurrentEventColor = Colors.icon2024_cream50_transparent_90
    static let homeNextEventColor = Colors.icon2024_cream50_transparent_90
    static let homeTimeTextColor = Colors.textColor
    static let homeTitleDuringConventionNoFavoritesTextColor = Colors.white
    static let homeTitleDuringConventionNoFavoritesBackgroundColor = Colors.icon2024_blue600
    static let homeTimeBoxContainerColor = Colors.icon2024_cream50_transparent_90
    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.textColor
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.icon2024_cream50
    static let homeCurrentEventHeadersBackgroundColor = Colors.icon2024_blue600
    static let homeUpcomingEventHeadersBackgroundColor = Colors.icon2024_blue200
    static let homeCurrentEventHeadersTextColor = Colors.icon2024_cream200
    static let homeUpcomingEventHeadersTextColor = Colors.textColor
    static let homeGoToMyEventsButtonColor = Colors.homeFirstButtonColor
    static let homeGoToMyEventsButtonTitleColor = Colors.homeFirstButtonTextColor
    static let homeTextColor = Colors.icon2024_gray800
    static let homeUpcomingEventTextColor = Colors.textColor
    static let homeCurrentEventTextColor = Colors.textColor

    
    // Updates colors
    static let updateTimeBackground = Colors.clear
    static let updateTimeTextColor = Colors.icon2024_clay600
    static let updateTextColor = Colors.textColor
    static let updateBackgroundColor = Colors.icon2024_cream50_transparent_90
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
    
    static let staticHtmlContentColor = Colors.icon2024_cream50
}
