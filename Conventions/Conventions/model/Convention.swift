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
    static let date = Date.from(year: 2024, month: 4, day: 24)
    static let endDate = Date.from(year: 2024, month: 4, day: 25)
    static let name = "olamot2024"
    static let displayName = "כנס עולמות 2024"
    
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
            
            Hall(name: "מפגשים"),
            Hall(name: "סדנאות"),
            Hall(name: "ילדים"),
            Hall(name: "חוצות"),
            Hall(name: "הזירה"),
            Hall(name: "אירועי חוצות 2"),
            Hall(name: "מיניאטורות 1"),
            Hall(name: "מיניאטורות: הדגמות"),
            
            Hall(name: "ארועים מיוחדים"),
            
            Hall(name: "עירוני 1"),
            Hall(name: "עירוני 2"),
            Hall(name: "עירוני 3"),
            Hall(name: "עירוני 4"),
            Hall(name: "עירוני 5"),
            Hall(name: "עירוני 6"),
            Hall(name: "עירוני 7"),
            Hall(name: "עירוני 8"),
            Hall(name: "עירוני 9"),
            
            Hall(name: "אוהל 1"),
            Hall(name: "אוהל 2"),
            Hall(name: "אוהל 3"),
            Hall(name: "אוהל 4"),
            Hall(name: "אוהל 5"),
            Hall(name: "אוהל 6"),
            Hall(name: "אוהל 7"),
            Hall(name: "אוהל 8"),
            Hall(name: "אוהל 20 טבעי"),
            
            Hall(name: "ארטמיס 1"),
            Hall(name: "ארטמיס 2"),
            Hall(name: "חדר בריחה"),
            
            Hall(name: "חדר סדנאות"),
            Hall(name: "משחקי קופסה 1"),
            Hall(name: "משחקי קופסה 2")
        ];
        
        halls.enumerated().forEach { (index, hall) in
            hall.order = index
        }
        
        events = Events(halls: halls)
        
        feedbackQuestions = [
            FeedbackQuestion(question:"באיזו מידה נהנית מהכנס?", answerType: .Smiley),
            FeedbackQuestion(question: "הצעות לשיפור ונושאים לשימור", answerType: .Text)
        ]
        
        conventionFeedbackForm = SurveyForm.Feedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdwefudcwQye8_91qW9wzocvVOYMFsrZyPG6P7_79qBCat57Q/formResponse")!,
            conventionNameEntry: "entry.1882876736",
            deviceIdEntry: "entry.312890800",
            questionToFormEntry: ["גיל" : "entry.415572741", "באיזו מידה נהנית מהכנס?" : "entry.1327236956", "האם המפה והשילוט היו ברורים ושימושיים?" : "entry.1416969956", "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?" : "entry.1582215667", "הצעות לשיפור ונושאים לשימור": "entry.993320932"])
        
        eventFeedbackForm = SurveyForm.EventFeedback(
            url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeIsX_1PjmOJrsk5468qphLsYh_1DVgx39bLh4y0v2KFZfn2w/formResponse")!,
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

