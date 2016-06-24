//
//  UserInputs.swift
//  Conventions
//
//  Created by David Bahat on 2/20/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class UserInputs {
    private static let storageFileName = Convention.name + "UserInputs.json";
    private static let storageFile = NSHomeDirectory() + "/Documents/" + UserInputs.storageFileName;
    
    // Maps eventId to the user input for that event
    private var eventInputs = Dictionary<String, ConventionEvent.UserInput>();
    
    init() {
        // Try to load the cached user inputs upon init
        if let cachedInputs = load() {
            eventInputs = cachedInputs;
        }
    }
    
    func getInput(forEventId: String) -> ConventionEvent.UserInput? {
        return eventInputs[forEventId];
    }
    
    func setInput(input: ConventionEvent.UserInput, forEventId: String) {
        eventInputs[forEventId] = input;
        save();
    }
    
    private func save() {
        let serilizableInputs = eventInputs.map({input in [input.0: input.1.toJson()]});
        
        let json = try? NSJSONSerialization.dataWithJSONObject(serilizableInputs, options: NSJSONWritingOptions.PrettyPrinted);
        json?.writeToFile(UserInputs.storageFile, atomically: true);
    }
    
    private func load() -> Dictionary<String, ConventionEvent.UserInput>? {
        guard let storedInputs = NSData(contentsOfFile: UserInputs.storageFile) else {
            return nil;
        }
        guard let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments) else {
            return nil;
        }
        guard let userInputs = userInputsJson as? [Dictionary<String, Dictionary<String, AnyObject>>] else {
            return nil;
        }
        
        var result = Dictionary<String, ConventionEvent.UserInput>();
        for userInput in userInputs {
            userInput.forEach({input in result[input.0] = ConventionEvent.UserInput(json: input.1)})
        }
        return result
    }
}