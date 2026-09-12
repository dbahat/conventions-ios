//
//  Colors.swift
//  Conventions
//
//  Created by David Bahat on 9/23/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Colors {

    static let icon2026_green50 = UIColor(hexString: "#EAFFDE")
    static let icon2026_green600 = UIColor(hexString: "#5CC225")
    static let icon2026_green900 = UIColor(hexString: "#348209")
    static let icon2026_green950 = UIColor(hexString: "#276B02")

    static let icon2026_brown25 = UIColor(hexString: "#F0DFE3")
    static let icon2026_brown50 = UIColor(hexString: "#E5CFD4")
    static let icon2026_brown100 = UIColor(hexString: "#D5B3BB")
    static let icon2026_brown200 = UIColor(hexString: "#BD939D")
    static let icon2026_brown400 = UIColor(hexString: "#894B59")
    static let icon2026_brown600 = UIColor(hexString: "#5C1A29")
    static let icon2026_brown700 = UIColor(hexString: "#4A0414")
    static let icon2026_brown800 = UIColor(hexString: "#3F0210")

    static let icon2026_blue50 = UIColor(hexString: "#CBE1F2")
    static let icon2026_blue500 = UIColor(hexString: "#4B93BF")
    static let icon2026_blue600 = UIColor(hexString: "#4084AE")
    static let icon2026_blue700 = UIColor(hexString: "#2973A1")
    static let icon2026_blue800 = UIColor(hexString: "#1A5C86")

    static let icon2026_purple25 = UIColor(hexString: "#FAF7FC")
    static let icon2026_purple50 = UIColor(hexString: "#EFE8F4")
    static let icon2026_purple100 = UIColor(hexString: "#DFD4E8")
    static let icon2026_purple200 = UIColor(hexString: "#BAA1CA")
    static let icon2026_purple400 = UIColor(hexString: "#6E4B87")
    static let icon2026_purple600 = UIColor(hexString: "#472360")

    static let icon2026_orange25 = UIColor(hexString: "#FFF7F2")
    static let icon2026_orange50 = UIColor(hexString: "#FCE6D9")
    static let icon2026_orange100 = UIColor(hexString: "#FADAC8")
    static let icon2026_orange300 = UIColor(hexString: "#F7BA99")
    static let icon2026_orange900 = UIColor(hexString: "#9E3E0A")

    static let icon2026_yellow25_95 = UIColor(hexString: "#F2FFFBF5")
    static let icon2026_yellow25 = UIColor(hexString: "#FFFBF5")
    static let icon2026_yellow100 = UIColor(hexString: "#FFF3DB")
    static let icon2026_yellow300 = UIColor(hexString: "#FFDD9C")
    static let icon2026_yellow400 = UIColor(hexString: "#FFCE73")
    static let icon2026_yellow500 = UIColor(hexString: "#FFC252")
    static let icon2026_yellow600 = UIColor(hexString: "#FFB326")

    static let icon2026_gray100 = UIColor(hexString: "#E6E7ED")
    static let icon2026_gray200 = UIColor(hexString: "#DCDEE5")
    static let icon2026_gray700 = UIColor(hexString: "#595B67")
    static let icon2026_gray800 = UIColor(hexString: "#414557")
    static let icon2026_gray900 = UIColor(hexString: "#2A2E42")
    static let icon2026_gray950 = UIColor(hexString: "#0D122B")

    static let icon2026_red = UIColor(hexString: "#DD2F31")
    static let icon2026_red2 = UIColor(hexString: "#FD7576")
    static let icon2026_bronze = UIColor(hexString: "#D08F65")


    static let black = UIColor.black
    static let white = UIColor.white
    static let clear = UIColor.clear
    
    static let colorAccent = Colors.icon2026_green950
    static let tabBarSelectedTabColor = Colors.icon2026_yellow500
    static let tabBarUnselectedTabColor = Colors.white
    static let tabBarBackgroundColor = Colors.icon2026_purple400
    static let textColor = Colors.icon2026_brown600
    static let hintTextColor = Colors.icon2026_brown600
    static let backgroundColor = Colors.clear
    static let linksColor = Colors.icon2026_blue700
    
    static let navigationBarBackgroundColor = Colors.clear
    static let navigationBarTextColor = Colors.textColor
    
    static let switchButtonsColor = Colors.icon2026_purple600
    static let datePickerColor = Colors.icon2026_purple25
    static let datePickerTextColor = Colors.icon2026_purple400
    static let datePickerBackgroundColor = Colors.icon2026_purple100
    static let eventTimeDefaultBackgroundColor = Colors.eventTimeHeaderColor
    static let eventTimeHeaderColor = Colors.icon2026_orange300
    static let eventTimeHeaderTextColor = Colors.icon2026_brown600
    static let buttonColor = Colors.icon2026_green900
    static let logoffButtonColor = Colors.icon2026_red
    static let buttonPressedColor = Colors.icon2026_green950
    static let buttonDisabledColor = Colors.icon2026_gray100
    
    static let feedbackButtonColor = Colors.buttonColor
    static let feedbackButtonPressedColor = Colors.buttonPressedColor
    
    static let feedbackButtonColorEvent = Colors.icon2026_green950
    static let feedbackButtonColorConvetion = Colors.icon2026_yellow600
    static let feedbackLinksColorEvent = Colors.linksColor
    static let feedbackLinksColorConvention = Colors.linksColor
    static let expandFeedbackButtonColor = Colors.icon2026_green950
    
    static let mapBackgroundColor = UIColor.clear
    
    // Events colors
    static let eventSearchBarTextColor = Colors.textColor
    static let eventEndedColor = Colors.icon2026_brown25
    static let eventRunningColor = Colors.icon2026_brown400
    static let eventNotStartedColor = Colors.icon2026_brown100
    static let eventRunningTimeTextColor = Colors.white
    static let eventNotRunningTimeTextColor = Colors.textColor
    static let eventUserNeedsToCompleteFeedbackButtonColor = Colors.icon2026_purple400
    static let eventFeedbackButtonNoFavorite = Colors.icon2026_purple400
    static let eventMarkedAsFavorite = Colors.icon2026_yellow600
    static let eventNotMarkedAsFavorite = Colors.icon2026_gray200
    static let eventSeperatorColor = Colors.clear
    static let eventOpenEventConatinerColor = Colors.icon2026_purple50
    static let eventTimeboxTextColor = Colors.eventContentTextColor
    static let eventTimeboxTextColorVirtual = Colors.eventTimeboxTextColor
    static let eventViewTitleAndDetailsContainerBackground = Colors.icon2026_yellow25
    static let eventContentTextColor = Colors.textColor
    static let eventFeedbackIconSentColor = Colors.icon2026_green600
    static let eventOngoingTagBackgroundColor = Colors.icon2026_blue50
    static let eventOngoingTagTextColor = Colors.icon2026_blue800
    
    // Event colors
    static let eventTitleBoxColor = Colors.clear
    static let eventDetailsBoxColor = Colors.icon2026_yellow25
    static let eventTitleBackground = Colors.clear
    static let eventTitleBoarderColor = Colors.clear
    static let eventTitleTextColor = Colors.icon2026_brown600
    static let eventSubTitleTextColor = Colors.icon2026_brown600
    static let eventFeedbackBoxColor = Colors.icon2026_green50
    static let eventFeedbackTextColor = Colors.icon2026_green950
    static let eventDescriptionTextColor = Colors.textColor
    static let eventTitleBackgroundColor = Colors.clear
    static let eventSubtitleBackgroundColor = Colors.clear
    static let eventTypeAndCategoryBackgroundColor = Colors.clear
    
    
    // SecondHand colorss
    static let secondHandClosedFormColor = Colors.icon2026_gray700
    static let secondHandOpenFormColor = Colors.icon2026_yellow25
    static let secondHandHeaderBackgroundColor = Colors.clear
    
    // Home colors
    static let homeFirstButtonColor = Colors.icon2026_purple600
    static let homeSecondButtonColor = Colors.icon2026_yellow500
    static let homeFirstButtonTextColor = Colors.icon2026_purple25
    static let homeSecondButtonTextColor = Colors.icon2026_brown600
    static let homeCurrentEventColor = Colors.icon2026_yellow25
    static let homeNextEventColor = Colors.icon2026_yellow25
    static let homeTitleDuringConventionNoFavoritesTextColor = Colors.icon2026_purple600
    static let homeTitleDuringConventionNoFavoritesBackgroundColor = Colors.clear

    static let homeDuringConvetionNoFavoriteCardTextColor = Colors.textColor
    static let homeDuringConvetionNoFavoriteCardBackgroundColor = Colors.icon2026_yellow25
    static let homeCurrentEventHeadersBackgroundColor = Colors.clear
    static let homeUpcomingEventHeadersBackgroundColor = Colors.clear
    static let homeCurrentEventHeadersTextColor = Colors.icon2026_purple600
    static let homeUpcomingEventHeadersTextColor = Colors.icon2026_purple600
    static let homeTextColor = Colors.textColor
    static let homeUpcomingEventTextColor = Colors.icon2026_brown700
    static let homeCurrentEventTextColor = Colors.icon2026_brown700

    
    // Updates colors
    static let updateTimeBackground = Colors.clear
    static let updateTimeTextColor = Colors.icon2026_purple400
    static let updateTextColor = Colors.textColor
    static let updateBackgroundColor = Colors.icon2026_yellow25
    static let newUpdateLabelBackgroundColor = Colors.icon2026_purple400
    
    // Map colors
    static let mapIndicatorColor = UIColor.clear
    static let mapIndicatorSelectedColor = UIColor.clear
    
    static let staticHtmlContentColor = Colors.icon2026_yellow25
    static let settingsBackgroundColor = Colors.clear
    static let conventionFeedbackViewBackgroundColor = Colors.icon2026_yellow25
    
    static let secondHandBackgroundColor = Colors.clear
    static let secondHandSeperatorColor = Colors.icon2026_purple400
    static let secondHandStatusClosedColor = Colors.icon2026_gray700
    static let secondHandStatusCreatedColor = Colors.icon2026_blue700
    static let secondHandStatusSoldColor = Colors.icon2026_green900
    static let secondHandStatusMissingColor = Colors.icon2026_red
    static let secondHandStatusDefaultColor = Colors.icon2026_purple600
    static let secondHandRemoveFormButtonColor = Colors.icon2026_blue700

    // Stands colors
    static let standsCardBackgroundColor = Colors.icon2026_yellow25
    static let standsCardTextColor = Colors.textColor
    static let standsCardSubtitleColor = Colors.icon2026_gray900
    static let standsCategoryBadgeBackgroundColor = Colors.icon2026_gray100
    static let standsCategoryBadgeTextColor = Colors.icon2026_gray800
    static let standCardIconColor = Colors.textColor
    static let standCardSubtitleColor = Colors.icon2026_gray900
    static let standFilterIconColor = Colors.icon2026_purple25
    static let standFilterContainerColor = Colors.icon2026_purple600
    static let standFilterOnIconColor = Colors.icon2026_purple600
    static let standFilterOnContainerColor = Colors.icon2026_purple25
    static let standsFilterScreenBackgroundColor = Colors.icon2026_yellow25
    static let standFilterSelectedColor = Colors.icon2026_blue500
    static let standZoomOutIconColor = Colors.icon2026_purple25
    static let standZoomOutContainerColor = Colors.icon2026_purple600
    static let standHighlightedTextColor = Colors.icon2026_blue500
    static let standDetailsSubtitleColor = Colors.icon2026_gray800
    static let standDetailsActiveLabelColor = Colors.icon2026_green950
    static let standDetailsDescriptionColor = Colors.icon2026_gray950
    static let standTagBackgroundColor = Colors.icon2026_orange50
    static let standTagTextColor = Colors.icon2026_orange900
    static let standCardMoreInfoColor = Colors.icon2026_blue700

}
