//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {
    
    static let olamot2026_blue25 = UIColor(hexString: "#EAF5FA")
    static let olamot2026_blue50 = UIColor(hexString: "#D8ECF6")
    static let olamot2026_blue100 = UIColor(hexString: "#B4D8EB")
    static let olamot2026_blue200 = UIColor(hexString: "#96C8E2")
    static let olamot2026_blue400 = UIColor(hexString: "#64A2C1")
    static let olamot2026_blue500 = UIColor(hexString: "#458EB2")
    static let olamot2026_blue600 = UIColor(hexString: "#29789F")
    static let olamot2026_blue700 = UIColor(hexString: "#17668D")
    static let olamot2026_blue900 = UIColor(hexString: "#034566")
    static let olamot2026_blue1000 = UIColor(hexString: "#003048")

    static let olamot2026_purple25 = UIColor(hexString: "#F3F0F5")
    static let olamot2026_purple100 = UIColor(hexString: "#E9E3EB")
    static let olamot2026_purple200 = UIColor(hexString: "#DDD2E2")
    static let olamot2026_purple400 = UIColor(hexString: "#B1A2B8")
    static let olamot2026_purple700 = UIColor(hexString: "#80668C")
    static let olamot2026_purple900 = UIColor(hexString: "#563963")
    static let olamot2026_purple1000 = UIColor(hexString: "#40274C")

    static let olamot2026_gray50 = UIColor(hexString: "#F7F8FA")
    static let olamot2026_gray100 = UIColor(hexString: "#EBECF0")
    static let olamot2026_gray200 = UIColor(hexString: "#D9DCE3")
    static let olamot2026_gray300 = UIColor(hexString: "#BCC0C8")
    static let olamot2026_gray600 = UIColor(hexString: "#545967")
    static let olamot2026_gray700 = UIColor(hexString: "#3C414D")
    static let olamot2026_gray800 = UIColor(hexString: "#2A3141")
    static let olamot2026_gray900 = UIColor(hexString: "#291D46")

    static let olamot2026_copper = UIColor(hexString: "#C89C6A")

    static let olamot2026_green25 = UIColor(hexString: "#F5FFFA")
    static let olamot2026_green100 = UIColor(hexString: "#D8F3E5")
    static let olamot2026_green200 = UIColor(hexString: "#BEEBD3")
    static let olamot2026_green700 = UIColor(hexString: "#3EA36D")
    static let olamot2026_green800 = UIColor(hexString: "#318E5D")
    static let olamot2026_green1000 = UIColor(hexString: "#105E35")
    static let olamot2026_green50_transparent_95 = UIColor(hexString: "#F2E6F7EE")

    static let olamot2026_red = UIColor(hexString: "#C5143A")

    
    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.olamot2026_blue700
    static let tabBarSelectedTabColor = Colors.olamot2026_copper
    static let tabBarUnselectedTabColor = Colors.white
    static let tabBarBackgroundColor = Colors.olamot2026_purple1000
    static let textColor = Colors.olamot2026_purple1000
    static let hintTextColor = Colors.olamot2026_blue700
    static let backgroundColor = Colors.clear
    static let linksColor = Colors.olamot2026_blue700
    
    static let navigationBarBackgroundColor = Colors.clear
    static let navigationBarTextColor = Colors.textColor
    
    static let switchButtonsColor = Colors.olamot2026_purple1000
    static let datePickerColor = Colors.olamot2026_purple25
    static let datePickerTextColor = Colors.olamot2026_purple1000
    static let datePickerBackgroundColor = Colors.olamot2026_purple25
    static let eventTimeDefaultBackgroundColor = Colors.eventTimeHeaderColor
    static let eventTimeHeaderColor = Colors.olamot2026_blue400
    static let eventTimeHeaderTextColor = Colors.white
    static let buttonColor = Colors.olamot2026_blue700
    static let logoffButtonColor = Colors.olamot2026_red
    static let buttonPressedColor = Colors.olamot2026_blue400
    static let buttonDisabledColor = Colors.olamot2026_gray200
    
    static let feedbackButtonColor = Colors.buttonColor
    static let feedbackButtonPressedColor = Colors.buttonPressedColor
    
    static let feedbackButtonColorEvent = Colors.olamot2026_blue700
    static let feedbackButtonColorConvetion = Colors.olamot2026_blue700
    static let feedbackLinksColorEvent = Colors.linksColor
    static let feedbackLinksColorConvention = Colors.linksColor
    static let expandFeedbackButtonColor = Colors.olamot2026_blue900
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventSearchBarTextColor = Colors.textColor
    static let eventEndedColor = Colors.olamot2026_blue50
    static let eventRunningColor = Colors.olamot2026_blue600
    static let eventNotStartedColor = Colors.olamot2026_blue200
    static let eventRunningTimeTextColor = Colors.white
    static let eventNotRunningTimeTextColor = Colors.textColor
    static let eventUserNeedsToCompleteFeedbackButtonColor = Colors.olamot2026_gray300
    static let eventFeedbackButtonNoFavorite = Colors.olamot2026_blue500
    static let eventMarkedAsFavorite = Colors.olamot2026_copper
    static let eventNotMarkedAsFavorite = Colors.olamot2026_gray300
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = Colors.olamot2026_purple100
    static let eventTimeboxTextColor = Colors.eventContentTextColor
    static let eventTimeboxTextColorVirtual = Colors.eventTimeboxTextColor
    static let eventViewTitleAndDetailsContainerBackground = Colors.olamot2026_gray50
    static let eventContentTextColor = Colors.textColor
    static let eventFeedbackIconSentColor = Colors.olamot2026_green700
    static let eventOngoingTagBackgroundColor = Colors.olamot2026_green200
    static let eventOngoingTagTextColor = Colors.olamot2026_green1000
    
    // Event colors
    static let eventTitleBoxColor = Colors.clear
    static let eventDetailsBoxColor = Colors.olamot2026_gray50
    static let eventTitleBackground = Colors.clear
    static let eventTitleBoarderColor = Colors.clear
    static let eventTitleTextColor = Colors.white
    static let eventSubTitleTextColor = Colors.olamot2026_blue900
    static let eventFeedbackBoxColor = Colors.olamot2026_blue100
    static let eventFeedbackTextColor = Colors.olamot2026_blue900
    static let eventDescriptionTextColor = Colors.textColor
    static let eventTitleBackgroundColor = Colors.olamot2026_blue25
    static let eventSubtitleBackgroundColor = Colors.olamot2026_blue100
    static let eventTypeAndCategoryBackgroundColor = Colors.olamot2026_blue700
    
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.olamot2026_gray600
    static let secondHandOpenFormColor = Colors.olamot2026_purple1000
    static let secondHandHeaderBackgroundColor = Colors.clear
    
    // Home colors
    static let homeFirstButtonColor = Colors.olamot2026_blue600
    static let homeSecondButtonColor = Colors.olamot2026_purple700
    static let homeFirstButtonTextColor = Colors.olamot2026_blue25
    static let homeSecondButtonTextColor = Colors.white
    static let homeCurrentEventColor = Colors.olamot2026_gray50
    static let homeNextEventColor = Colors.olamot2026_gray50
    static let homeTitleDuringConventionNoFavoritesTextColor = Colors.olamot2026_blue1000
    static let homeTitleDuringConventionNoFavoritesBackgroundColor = Colors.olamot2026_blue200

    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.olamot2026_gray800
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.olamot2026_gray50
    static let homeCurrentEventHeadersBackgroundColor = Colors.olamot2026_blue600
    static let homeUpcomingEventHeadersBackgroundColor = Colors.olamot2026_blue200
    static let homeCurrentEventHeadersTextColor = Colors.white
    static let homeUpcomingEventHeadersTextColor = Colors.olamot2026_blue1000
    static let homeTextColor = Colors.olamot2026_gray800
    static let homeUpcomingEventTextColor = Colors.olamot2026_gray800
    static let homeCurrentEventTextColor = Colors.olamot2026_gray800

    
    // Updates colors
    static let updateTimeBackground = Colors.clear
    static let updateTimeTextColor = Colors.olamot2026_blue700
    static let updateTextColor = Colors.textColor
    static let updateBackgroundColor = Colors.olamot2026_gray50
    static let newUpdateLabelBackgroundColor = Colors.olamot2026_blue700
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
    
    static let staticHtmlContentColor = Colors.olamot2026_gray50
    static let settingsBackgroundColor = Colors.clear
    static let conventionFeedbackViewBackgroundColor = Colors.olamot2026_gray50
    
    static let secondHandBackgroundColor = Colors.clear
    static let secondHandSeperatorColor = Colors.olamot2026_purple400
    static let secondHandStatusClosedColor = Colors.olamot2026_gray600
    static let secondHandStatusCreatedColor = Colors.olamot2026_blue700
    static let secondHandStatusSoldColor = Colors.olamot2026_green800
    static let secondHandStatusMissingColor = Colors.olamot2026_red
    static let secondHandStatusDefaultColor = Colors.olamot2026_purple1000
    static let secondHandRemoveFormButtonColor = Colors.olamot2026_blue700
    
}
