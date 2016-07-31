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
    static let date = NSDate.from(year: 2016, month: 8, day: 25)
    static let name = "Cami2016"
    static let displayName = "כאמ\"י 2016"
    static let mailbox = "dbahat@live.com"
    
    var halls: Array<Hall>
    var events: Events
    var updates = Updates()
    
    let eventsInputs = UserInputs.Events()
    
    let feedback = UserInputs.ConventionInputs()
    let feedbackQuestions: Array<FeedbackQuestion>
 
    init() {
        halls = [
            Hall(name: "אולם ראשי", order: 1),
            Hall(name: "אודיטוריום שוורץ", order: 2),
            Hall(name: "אשכול 1", order: 3),
            Hall(name: "אשכול 2", order: 4),
            Hall(name: "אשכול 3", order: 5)
        ];
        
        events = Events(halls: halls)
        
        feedbackQuestions = [
            FeedbackQuestion(question:"גיל", answerType: .MultipleAnswer, answersToSelectFrom: [
                "פחות מ-12", "17-12", "25-18", "+25"
                ]),
            FeedbackQuestion(question:"עד כמה נהנית בכנס?", answerType: .Smiley),
            FeedbackQuestion(question:"האם המפה והשילוט היו ברורים ושימושיים?", answerType: .MultipleAnswer, answersToSelectFrom: [
                "כן", "לא"
                ]),
            FeedbackQuestion(question: "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?", answerType: .TableMultipleAnswer, answersToSelectFrom: [
                "האירוע התנגש עם אירוע אחר שהלכתי אילו",
                "לא הצלחתי למצא את החדר",
                "האירוע התרחש מוקדם או מאוחר מידי",
                "סיבה אחרת",
                ]),
            FeedbackQuestion(question: "הצעות לשיפור ודברים לשימור", answerType: .Text)
        ]
    }
    
    func findHallByName(name: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: "אירועים מיוחדים", order: 6)
    }
    
    func isFeedbackSendingTimeOver() -> Bool {
        // Check if the event will end in 15 minutes or less
        return NSDate().compare(Convention.date.addDays(14)) == .OrderedDescending
    }
}

