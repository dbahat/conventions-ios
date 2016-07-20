//
//  UserInputs.swift
//  Conventions
//
//  Created by David Bahat on 2/20/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class UserInputs {
    
    class Events {
        private static let eventsStorageFileName = Convention.name + "EventsInputs.json";
        private static let eventsStorageFile = NSHomeDirectory() + "/Documents/" + UserInputs.Events.eventsStorageFileName;
        
        // Maps eventId to the user input for that event
        private var eventInputs = Dictionary<String, UserInput.ConventionEvent>();
        
        init() {
            // Try to load the cached user inputs upon init
            if let cachedEventInputs = loadEventFeedbacks() {
                eventInputs = cachedEventInputs;
            }
        }
        
        func getInput(forEventId: String) -> UserInput.ConventionEvent? {
            return eventInputs[forEventId];
        }
        
        func setInput(input: UserInput.ConventionEvent, forEventId: String) {
            eventInputs[forEventId] = input;
        }
        
        func save() {
            let serilizableInputs = eventInputs.map({input in [input.0: input.1.toJson()]});
            
            let json = try? NSJSONSerialization.dataWithJSONObject(serilizableInputs, options: NSJSONWritingOptions.PrettyPrinted);
            json?.writeToFile(UserInputs.Events.eventsStorageFileName, atomically: true);
        }
        
        private func loadEventFeedbacks() -> Dictionary<String, UserInput.ConventionEvent>? {
            guard let storedInputs = NSData(contentsOfFile: UserInputs.Events.eventsStorageFileName) else {
                return nil;
            }
            guard let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments) else {
                return nil;
            }
            guard let userInputs = userInputsJson as? [Dictionary<String, Dictionary<String, AnyObject>>] else {
                return nil;
            }
            
            var result = Dictionary<String, UserInput.ConventionEvent>();
            for userInput in userInputs {
                userInput.forEach({input in result[input.0] = UserInput.ConventionEvent(json: input.1)})
            }
            return result
        }
    }
    
    class ConventionInputs {
        private static let conventionStorageFileName = Convention.name + "ConventionInputs.json";
        private static let conventionStorageFile = NSHomeDirectory() + "/Documents/" + UserInputs.ConventionInputs.conventionStorageFileName;
        
        
        private var conventionInputs = UserInput.Feedback()
        
        init() {
            if let cachedConventionInputs = loadConventionFeedback() {
                conventionInputs = cachedConventionInputs;
            }
        }
        
        func save() {
            let json = try? NSJSONSerialization.dataWithJSONObject(conventionInputs.toJson(), options: NSJSONWritingOptions.PrettyPrinted);
            json?.writeToFile(UserInputs.Events.eventsStorageFileName, atomically: true);
        }
        
        private func loadConventionFeedback() -> UserInput.Feedback? {
            guard
                let storedInputs = NSData(contentsOfFile: UserInputs.ConventionInputs.conventionStorageFileName),
                let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments),
                let userInputs = userInputsJson as? Dictionary<String, AnyObject>
                else {
                    return nil;
            }
            
            return UserInput.Feedback(json: userInputs)
        }
    }
}