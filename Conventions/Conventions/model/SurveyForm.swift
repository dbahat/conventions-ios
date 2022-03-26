//
//  SurveyForm.swift
//  Conventions
//
//  Created by David Bahat on 8/28/17.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class SurveyForm {
    let url: URL
    let questionToFormEntry: Dictionary<String, String>
    
    init(url: URL, questionToFormEntry: Dictionary<String, String>) {
        self.url = url
        self.questionToFormEntry = questionToFormEntry
    }
    
    func submit(_ answers: Array<FeedbackAnswer>, callback: ((_ success: Bool) -> Void)?) {
        submit(generatePostBody(answers: answers), callback: callback)
    }
    
    fileprivate func generatePostBody(answers: Array<FeedbackAnswer>) -> String {
        return answers.map({answer in
            String(format: "%@=%@", findFormEntryId(questionText: answer.questionText), answer.getAnswer().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        }).joined(separator:"&")
    }
    
    private func submit(_ postBody: String, callback: ((_ success: Bool) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    callback?(false)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                DispatchQueue.main.async {
                    callback?(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                callback?(true)
            }
            
        }.resume()
    }

    private func findFormEntryId(questionText: String) -> String {
        // Force unwrapping since we want to fail fast in case the question text doesn't match the form ID
        return questionToFormEntry[questionText]!
    }
    
    class Feedback : SurveyForm {
        let conventionNameEntry: String
        let deviceIdEntry: String
        
        init(url: URL, conventionNameEntry: String, deviceIdEntry: String, questionToFormEntry: Dictionary<String, String>) {
            self.conventionNameEntry = conventionNameEntry
            self.deviceIdEntry = deviceIdEntry
            
            super.init(url: url, questionToFormEntry: questionToFormEntry)
        }
        
        func submit(conventionName: String, answers: Array<FeedbackAnswer>, callback: ((_ success: Bool) -> Void)?) {
            submit(generatePostBody(conventionName: conventionName, answers: answers), callback: callback)
        }
        
        fileprivate func generatePostBody(conventionName: String, answers: Array<FeedbackAnswer>) -> String {
            var postString = generatePostBody(answers: answers)
            
            postString.append(String(format: "&%@=%@",
                                     conventionNameEntry,
                                     conventionName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
            
            if let deviceId = UIDevice.current.identifierForVendor {
                postString.append(String(format: "&%@=%@", deviceIdEntry, deviceId.uuidString))
            }

            return postString
        }
    }
    
    class EventFeedback : Feedback {
        let eventTitleEntry: String
        let eventTimeEntry: String
        let hallEntry: String
        
        init(url: URL,
             conventionNameEntry: String,
             deviceIdEntry: String,
             eventTitleEntry: String,
             eventTimeEntry: String,
             hallEntry: String,
             questionToFormEntry: Dictionary<String, String>) {

            self.eventTitleEntry = eventTitleEntry
            self.eventTimeEntry = eventTimeEntry
            self.hallEntry = hallEntry
            
            super.init(url: url, conventionNameEntry: conventionNameEntry, deviceIdEntry: deviceIdEntry, questionToFormEntry: questionToFormEntry)
        }
        
        func submit(conventionName: String,
                    event: ConventionEvent,
                    answers: Array<FeedbackAnswer>,
                    callback: ((_ success: Bool) -> Void)?) {
            
            submit(generatePostBody(conventionName: conventionName, event: event, answers: answers),
                   callback: callback)
        }
        
        private func generatePostBody(conventionName: String,
                                          event: ConventionEvent,
                                          answers: Array<FeedbackAnswer>) -> String {
            
            return generatePostBody(conventionName: conventionName, answers: answers)
                .appending(
                    String(format: "&%@=%@",
                           eventTitleEntry,
                           event.title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
                .appending(
                    String(format: "&%@=%@",
                           eventTimeEntry,
                           event.startTime.format("dd.MM.yyyy HH:mm")))
                .appending(
                    String(format: "&%@=%@",
                           hallEntry,
                           event.hall.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
        }
    }
}
