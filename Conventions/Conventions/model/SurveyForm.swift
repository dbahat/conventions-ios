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
            String(format: "%@=%@", findFormEntryId(questionText: answer.questionText), answer.getAnswer())
        }).joined(separator:"&")
    }
    
    private func submit(_ postBody: String, callback: ((_ success: Bool) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
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
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    callback?(false)
                }
                return
            }
            
            // Check if the form was sent successfully
            // Unfortunately, even for unsuccessful send we get a 200 response, so we need to check the output.
            // There is no indication of error messages, but the "form was sent" message has class "freebirdFormviewerViewResponseConfirmationMessage"
            // in case of a new form and "ss-resp-message" in case of an old form so we check if one of them exists (the success message itself is localized so we can't check its text).
            if (!responseString.contains("freebirdFormviewerViewResponseConfirmationMessage")
                && !responseString.contains("ss-resp-message")) {
                
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
