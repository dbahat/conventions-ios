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
    static let date = Date.from(year: 2018, month: 4, day: 3)
    static let endDate = Date.from(year: 2018, month: 4, day: 4)
    static let name = "Olamot2018"
    static let displayName = "כנס עולמות"
    static let mailbox = "info@olamot-con.org.il"
    
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
        halls = [
            Hall(name: "סינמטק 1", order: 1),
            Hall(name: "סינמטק 2", order: 2),
            Hall(name: "סינמטק 5", order: 3),
            Hall(name: "אשכול 1", order: 4),
            Hall(name: "אשכול 2", order: 5),
            Hall(name: "אשכול 3", order: 6),
            Hall(name: "אשכול 4", order: 7),
            Hall(name: "אשכול 5", order: 8),
            Hall(name: "אשכול 6", order: 9),
            Hall(name: "חדר סדנאות", order: 10),
            Hall(name: "ארועים מיוחדים", order: 11),
            Hall(name: "חדר ילדים", order: 12),
            Hall(name: "חדר מפגשים", order: 13),
            Hall(name: "אירועי חוצות", order: 14),
            Hall(name: "אירועי חוצות 2", order: 15)
        ];
        
        events = Events(halls: halls)
        
        feedbackQuestions = [
            FeedbackQuestion(question:"גיל", answerType: .MultipleAnswer, answersToSelectFrom: [
                "פחות מ-12", "17–12", "25–18", "+25"
                ]),
            FeedbackQuestion(question:"באיזו מידה נהנית מהכנס?", answerType: .Smiley),
            FeedbackQuestion(question:"האם המפה והשילוט היו ברורים ושימושיים?", answerType: .MultipleAnswer, answersToSelectFrom: [
                "כן", "לא"
                ]),
            FeedbackQuestion(question: "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?", answerType: .TableMultipleAnswer, answersToSelectFrom: [
                "האירוע התנגש עם אירוע אחר שהלכתי אילו",
                "לא הצלחתי למצא את מקום האירוע",
                "האירוע התרחש מוקדם או מאוחר מידי",
                "סיבה אחרת",
                ]),
            FeedbackQuestion(question: "הצעות לשיפור ונושאים לשימור", answerType: .Text)
        ]
        
        conventionFeedbackForm = SurveyForm.Feedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfJOj3aZVn0rXMeVC3QQFEW-KqFQIDMZNgyFZZXJ12rGALv_Q/formResponse")!,
            conventionNameEntry: "entry.1882876736",
            deviceIdEntry: "entry.312890800",
            questionToFormEntry: ["גיל" : "entry.415572741", "באיזו מידה נהנית מהכנס?" : "entry.1327236956", "האם המפה והשילוט היו ברורים ושימושיים?" : "entry.1416969956", "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?" : "entry.1582215667", "הצעות לשיפור ונושאים לשימור": "entry.993320932"])
        
        eventFeedbackForm = SurveyForm.EventFeedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScgj-A0zvfZqKCTfyp3poGViDCJcFU8sESuKvbKJHlzX3-PBQ/formResponse")!,
            conventionNameEntry: "entry.1882876736",
            deviceIdEntry: "entry.312890800",
            eventTitleEntry: "entry.1847107867",
            eventTimeEntry: "entry.1648362575",
            hallEntry: "entry.1510105148",
            questionToFormEntry: ["האם נהנית באירוע?": "entry.415572741", "ההנחיה באירוע היתה:" : "entry.1327236956", "האם תרצה לבוא לאירועים בנושאים דומים בעתיד?": "entry.1416969956", "עוד משהו?": "entry.1582215667"])
    }
    
    func findHallByName(_ name: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: name, order: 999)
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

