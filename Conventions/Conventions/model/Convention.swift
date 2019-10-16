//
//  Convention.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Convention {
    static let instance = Convention()
    static let date = Date.from(year: 2019, month: 10, day: 15)
    static let endDate = Date.from(year: 2019, month: 10, day: 17)
    static let name = "Icon2019"
    static let displayName = "פסטיבל אייקון 2019"
    
    var halls: Array<Hall>
    var events: Events
    var updates = Updates()
    
    let eventsInputs = UserInputs.Events()
    
    let feedback = UserInputs.ConventionInputs()
    let feedbackQuestions: Array<FeedbackQuestion>
    
    let eventFeedbackForm: SurveyForm.EventFeedback
    let conventionFeedbackForm: SurveyForm.Feedback
    
    let secondHand = SecondHand()
    
    fileprivate init() {
        // The hall order affects the order the events are shown in the programme. Order was selected based on the convention website.
        halls = [
            Hall(name: "סינמטק 1"),
            Hall(name: "סינמטק 2"),
            Hall(name: "סינמטק 5"),
            
            Hall(name: "אשכול 1"),
            Hall(name: "אשכול 2"),
            Hall(name: "אשכול 3"),
            Hall(name: "אשכול 4"),
            Hall(name: "אשכול 5"),
            Hall(name: "אשכול 6"),
            
            Hall(name: "חדר מפגשים"),
            Hall(name: "סדנאות 1"),
            Hall(name: "סדנאות 2"),
            Hall(name: "חדר ילדים"),
            Hall(name: "אירועי חוצות"),
            Hall(name: "אירועי חוצות 2"),
            Hall(name: "מיניאטורות 1"),
            Hall(name: "מיניאטורות: הדגמות"),
            
            Hall(name: "ארועים מיוחדים"),
            
            Hall(name: "עירוני 1"),
            Hall(name: "עירוני 2"),
            Hall(name: "עירוני 3"),
            Hall(name: "עירוני 4"),
            Hall(name: "עירוני 5"),
            
            Hall(name: "אוהל 1"),
            Hall(name: "אוהל 2"),
            Hall(name: "אוהל 3"),
            Hall(name: "אוהל 4"),
            Hall(name: "אוהל 5"),
            Hall(name: "אוהל 6"),
            Hall(name: "אוהל 7"),
            Hall(name: "אוהל 8"),
            
            Hall(name: "ארטמיס 1"),
            Hall(name: "ארטמיס 2"),
            Hall(name: "חדר בריחה"),
            
            Hall(name: "חדר סדנאות")
        ];
        
        halls.enumerated().forEach { (index, hall) in
            hall.order = index
        }
        
        events = Events(halls: halls)
        
        feedbackQuestions = [
//            FeedbackQuestion(question:"גיל", answerType: .MultipleAnswer, answersToSelectFrom: [
//                "פחות מ-12", "17–12", "25–18", "+25"
//                ]),
            FeedbackQuestion(question:"באיזו מידה נהנית מהפסטיבל?", answerType: .Smiley),
//            FeedbackQuestion(question:"האם המפה והשילוט היו ברורים ושימושיים?", answerType: .MultipleAnswer, answersToSelectFrom: [
//                "כן", "לא"
//                ]),
//            FeedbackQuestion(question: "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?", answerType: .TableMultipleAnswer, answersToSelectFrom: [
//                "האירוע התנגש עם אירוע אחר שהלכתי אילו",
//                "לא הצלחתי למצא את מקום האירוע",
//                "האירוע התרחש מוקדם או מאוחר מידי",
//                "סיבה אחרת",
//                ]),
            FeedbackQuestion(question: "הצעות לשיפור ונושאים לשימור", answerType: .Text)
        ]
        
        conventionFeedbackForm = SurveyForm.Feedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScbDYud3x8OfSd-53GY11TrRJVWqdxI6_2wT3DbAEIe1IJ_fg/formResponse")!,
            conventionNameEntry: "entry.1882876736",
            deviceIdEntry: "entry.312890800",
            questionToFormEntry: ["גיל" : "entry.415572741", "באיזו מידה נהנית מהפסטיבל?" : "entry.1327236956", "האם המפה והשילוט היו ברורים ושימושיים?" : "entry.1416969956", "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?" : "entry.1582215667", "הצעות לשיפור ונושאים לשימור": "entry.993320932"])
        
        eventFeedbackForm = SurveyForm.EventFeedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfraYvfQm83clQrqyQ_F9QGK2Qv5-fXQRilMClSiV0EB5-EKA/formResponse")!,
            conventionNameEntry: "entry.1882876736",
            deviceIdEntry: "entry.312890800",
            eventTitleEntry: "entry.1847107867",
            eventTimeEntry: "entry.1648362575",
            hallEntry: "entry.1510105148",
            questionToFormEntry: ["האם נהנית באירוע?": "entry.415572741", "ההנחיה באירוע היתה:" : "entry.1327236956", "האם תרצה לבוא לאירועים בנושאים דומים בעתיד?": "entry.1416969956", "נשמח לדעת למה": "entry.1582215667"])
    }
    
    func findHallByName(_ name: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: name)
    }
    
    func isFeedbackSendingTimeOver() -> Bool {
        return Date.now().compare(Convention.endDate.addDays(7)) == .orderedDescending
    }
    
    func canFillConventionFeedback() -> Bool {
        return Date.now().compare(Convention.date.addHours(2)) == .orderedDescending
    }
    
    // returns true iif the convention is current running
    func isRunning() -> Bool {
        let currentDate = Date.now()
        return currentDate.timeIntervalSince1970 >= Convention.date.timeIntervalSince1970
            && currentDate.timeIntervalSince1970 <= Convention.endDate.addDays(1).timeIntervalSince1970
    }
}

