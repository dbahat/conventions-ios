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
        fileprivate static let eventsStorageFileName = Convention.name + "EventsInputs.json";
        fileprivate static let eventsStorageFile = NSHomeDirectory() + "/Documents/" + UserInputs.Events.eventsStorageFileName;
        
        // Maps eventId to the user input for that event
        fileprivate var eventInputs = Dictionary<String, UserInput.ConventionEventInput>();
        
        init() {
            // Try to load the cached user inputs upon init
            if let cachedEventInputs = loadEventFeedbacks() {
                eventInputs = cachedEventInputs;
            }
        }
        
        func getInput(_ forEventId: String) -> UserInput.ConventionEventInput? {
            return eventInputs[forEventId];
        }
        
        func setInput(_ input: UserInput.ConventionEventInput, forEventId: String) {
            eventInputs[forEventId] = input;
        }
        
        func save() {
            let serilizableInputs = eventInputs.map({input in [input.0: input.1.toJson()]});
            
            let json = try? JSONSerialization.data(withJSONObject: serilizableInputs, options: JSONSerialization.WritingOptions.prettyPrinted);
            ((try? json?.write(to: URL(fileURLWithPath: UserInputs.Events.eventsStorageFile), options: [.atomic])) as ()??);
        }
        
        fileprivate func loadEventFeedbacks() -> Dictionary<String, UserInput.ConventionEventInput>? {
            guard let storedInputs = try? Data(contentsOf: URL(fileURLWithPath: UserInputs.Events.eventsStorageFile)) else {
                return nil;
            }
            guard let userInputsJson = try? JSONSerialization.jsonObject(with: storedInputs, options: JSONSerialization.ReadingOptions.allowFragments) else {
                return nil;
            }
            guard let userInputs = userInputsJson as? [Dictionary<String, Dictionary<String, AnyObject>>] else {
                return nil;
            }
            
            var result = Dictionary<String, UserInput.ConventionEventInput>();
            for userInput in userInputs {
                userInput.forEach({input in result[input.0] = UserInput.ConventionEventInput(json: input.1)})
            }
            return result
        }
    }
    
    class ConventionInputs {
        fileprivate static let conventionStorageFileName = Convention.name + "ConventionInputs.json";
        fileprivate static let conventionStorageFile = NSHomeDirectory() + "/Documents/" + UserInputs.ConventionInputs.conventionStorageFileName;
        
        fileprivate(set) var conventionInputs = UserInput.Feedback()
        
        init() {
            if let cachedConventionInputs = loadConventionFeedback() {
                conventionInputs = cachedConventionInputs;
            }
        }
        
        func save() {
            let json = try? JSONSerialization.data(withJSONObject: conventionInputs.toJson(), options: JSONSerialization.WritingOptions.prettyPrinted);
            ((try? json?.write(to: URL(fileURLWithPath: UserInputs.ConventionInputs.conventionStorageFile), options: [.atomic])) as ()??);
        }
        
        fileprivate func loadConventionFeedback() -> UserInput.Feedback? {
            guard
                let storedInputs = try? Data(contentsOf: URL(fileURLWithPath: UserInputs.ConventionInputs.conventionStorageFile)),
                let userInputsJson = try? JSONSerialization.jsonObject(with: storedInputs, options: JSONSerialization.ReadingOptions.allowFragments),
                let userInputs = userInputsJson as? Dictionary<String, AnyObject>
                else {
                    return nil;
            }
            
            return UserInput.Feedback(json: userInputs)
        }
    }
}
