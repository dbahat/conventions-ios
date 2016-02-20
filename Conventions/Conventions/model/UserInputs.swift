//
//  UserInputs.swift
//  Conventions
//
//  Created by David Bahat on 2/20/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class UserInputs {
    private static let userInputFileName = NSHomeDirectory() + "/Documents/CamiUserInput.json";
    private var inputs = Dictionary<String, ConventionEvent.UserInput>();
    
    init() {
        // Try to load the cached user inputs upon init
        if let cachedInputs = load() {
            inputs = cachedInputs;
        }
    }
    
    func getInput(forEventId: String) -> ConventionEvent.UserInput? {
        return inputs[forEventId];
    }
    
    func setInput(input: ConventionEvent.UserInput, forEventId: String) {
        inputs[forEventId] = input;
        save();
    }
    
    private func save() {
        // Map each eventId to a Json object (represented by a Dictionary<String, String> type)
        var serilizableInputs = Dictionary<String, Dictionary<String, String>>();
        
        // First call toJson for all UserInput objects
        for input in inputs {
            serilizableInputs[input.0] = input.1.toJson();
        }
        
        let json = try? NSJSONSerialization.dataWithJSONObject(serilizableInputs, options: NSJSONWritingOptions.PrettyPrinted);
        json?.writeToFile(UserInputs.userInputFileName, atomically: true);
    }
    
    private func load() -> Dictionary<String, ConventionEvent.UserInput>? {
        guard let storedInputs = NSData(contentsOfFile: UserInputs.userInputFileName) else {
            return nil;
        }
        guard let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments) else {
            return nil;
        }
        guard let userInputsDict = userInputsJson as? Dictionary<String, Dictionary<String, String>> else {
            return nil;
        }
        
        var result = Dictionary<String, ConventionEvent.UserInput>();
        for userInputJson in userInputsDict {
            result[userInputJson.0] = ConventionEvent.UserInput(json: userInputJson.1);
        }
        return result;
    }
}