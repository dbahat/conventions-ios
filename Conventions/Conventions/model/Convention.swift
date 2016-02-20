//
//  Convention.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Convention {
    let userInputFileName = NSHomeDirectory() + "/Documents/CamiUserInput.json";
    
    static let instance = Convention();
    
    var halls: Array<Hall>?;
    var events: Array<ConventionEvent>!;
    var userInputs : Dictionary<String, ConventionEvent.UserInput>!;
    let date = Date.from(year: 2016, month: 3, day: 23);
    
    init() {
        userInputs = Dictionary<String, ConventionEvent.UserInput>();
        
        readUserInputs();
    }
    
    func saveUserInputs() {
        var serilizableUserInput = Dictionary<String, Dictionary<String, String>>();
        for userInput in userInputs {
            serilizableUserInput[userInput.0] = userInput.1.toJson();
        }
        let json = try? NSJSONSerialization.dataWithJSONObject(serilizableUserInput, options: NSJSONWritingOptions.PrettyPrinted);
        json?.writeToFile(userInputFileName, atomically: true);
    }
    
    func readUserInputs() {
        guard let storedInputs = NSData(contentsOfFile: userInputFileName) else {
            return;
        }
        guard let userInputsJson = try? NSJSONSerialization.JSONObjectWithData(storedInputs, options: NSJSONReadingOptions.AllowFragments) else {
            return;
        }
        guard let userInputsDict = userInputsJson as? Dictionary<String, Dictionary<String, String>> else {
            return;
        }
        
        var result = Dictionary<String, ConventionEvent.UserInput>();
        for userInputJson in userInputsDict {
            result[userInputJson.0] = ConventionEvent.UserInput(json: userInputJson.1);
        }
        userInputs = result;
    }
}

