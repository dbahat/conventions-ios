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
    static let date = Date.from(year: 2016, month: 10, day: 18)
    static let endDate = Date.from(year: 2016, month: 10, day: 20)
    static let name = "Icon2016"
    static let displayName = "פסטיבל אייקון 2016"
    static let mailbox = "feedback@iconfestival.org.il"
    
    // The APNS token. Set during app init, and saved here in case the user wish to change his push
    // notifications topics (which requires re-registration)
    static var deviceToken = Data()
    
    var halls: Array<Hall>
    var events: Events
    var updates = Updates()
    
    let eventsInputs = UserInputs.Events()
    
    let feedback = UserInputs.ConventionInputs()
    let feedbackQuestions: Array<FeedbackQuestion>
    
    fileprivate init() {
        halls = [
            Hall(name: "סינמטק 1", order: 1),
            Hall(name: "סינמטק 2", order: 2),
            Hall(name: "אשכול 1", order: 3),
            Hall(name: "אשכול 2", order: 4),
            Hall(name: "אשכול 3", order: 5),
            Hall(name: "אשכול 4", order: 6),
            Hall(name: "אשכול 5", order: 7),
            Hall(name: "אשכול 6", order: 8),
            Hall(name: "חדר סדנאות 1", order: 9),
            Hall(name: "חדר סדנאות 2", order: 10),
            Hall(name: "ארועים מיוחדים", order: 11),
            Hall(name: "עירוני 1", order: 12),
            Hall(name: "עירוני 2", order: 13),
            Hall(name: "עירוני 3", order: 14),
            Hall(name: "עירוני 4", order: 15),
            Hall(name: "עירוני 5", order: 16),
            Hall(name: "עירוני 6", order: 17),
            Hall(name: "עירוני 7", order: 18),
            Hall(name: "עירוני 8", order: 19),
            Hall(name: "עירוני 9", order: 20),
            Hall(name: "עירוני 10", order: 21),
            Hall(name: "עירוני 11", order: 22),
            Hall(name: "עירוני 12", order: 23)
        ];
        
        events = Events(halls: halls)
        
        feedbackQuestions = [
            FeedbackQuestion(question:"גיל", answerType: .multipleAnswer, answersToSelectFrom: [
                "פחות מ-12", "17–12", "25–18", "25+"
                ]),
            FeedbackQuestion(question:"באיזו מידה נהנית מהפסטיבל?", answerType: .smiley),
            FeedbackQuestion(question:"האם המפה והשילוט היו ברורים ושימושיים?", answerType: .multipleAnswer, answersToSelectFrom: [
                "כן", "לא"
                ]),
            FeedbackQuestion(question: "אם היה אירוע שרצית ללכת אילו ולא הלכת, מה הסיבה לכך?", answerType: .tableMultipleAnswer, answersToSelectFrom: [
                "האירוע התנגש עם אירוע אחר שהלכתי אילו",
                "לא הצלחתי למצא את מקום האירוע",
                "האירוע התרחש מוקדם או מאוחר מידי",
                "סיבה אחרת",
                ]),
            FeedbackQuestion(question: "הצעות לשיפור ונושאים לשימור", answerType: .text)
        ]
    }
    
    func findHallByName(_ name: String) -> Hall {
        if let hall = halls.filter({hall in hall.name == name}).first {
            return hall
        }
        print("Couldn't find hall ", name, ". Using default hall.");
        return Hall(name: name, order: 999)
    }
    
    func isFeedbackSendingTimeOver() -> Bool {
        return Date().compare(Convention.endDate.addDays(14)) == .orderedDescending
    }
    
    func canFillConventionFeedback() -> Bool {
        return Date().compare(Convention.date.addDays(1)) == .orderedDescending
    }
    
    // returns true iif the convention is current running
    func isRunning() -> Bool {
        let currentDate = Date()
        return currentDate.timeIntervalSince1970 >= Convention.date.timeIntervalSince1970
            && currentDate.timeIntervalSince1970 <= Convention.endDate.addDays(1).timeIntervalSince1970
    }
}

