//
//  SecondHandForms.swift
//  Conventions
//
//  Created by David Bahat on 30/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class SecondHand {
    private static let refreshUrl = "https://api.sf-f.org.il/yad2/form?formId="
    private static let fileName = Convention.name + "SecondHand.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "1_" + fileName;

    var forms: Array<SecondHand.Form> = [] {
        didSet {
            self.save()
        }
    }
    
    init() {
        let jsonDecoder = JSONDecoder()
        if
            let cachedForms = try? Data(contentsOf: URL(fileURLWithPath: SecondHand.cacheFile)),
            let forms = try? jsonDecoder.decode(Array<SecondHand.Form>.self, from: cachedForms) {
            self.forms = forms
        }
    }
    
    func refresh(formId: Int, _ callback: ((Bool) -> Void)?) {
        let url = URL(string: SecondHand.refreshUrl + String(formId))!
        
        URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) -> Void in
            let decoder = JSONDecoder()
            
            guard
                let jsonData = data,
                let forms = try? decoder.decode(Array<Form>.self, from: jsonData)
                else {
                    DispatchQueue.main.async {
                        callback?(false)
                    }
                    return
            }
            
            DispatchQueue.main.async {
                if (forms.count == 0) {
                    callback?(false)
                    return
                }
                
                // Remove the form if it already existed
                if let formToRemove = self.forms.index(where: ({$0.id == formId})) {
                    self.forms.remove(at: formToRemove)
                }
                self.forms.append(forms.first!)
                self.save()
                print("downloaded form " + String(formId))
                
                callback?(true)
            }
        }).resume()
    }
    
    private var numRefresh = 0
    private var totalSuccess = true
        
    func refresh(_ callback: ((Bool) -> Void)?) {
        // since there's currently no API to refresh multiple forms, send a request per form
        for form in forms {
            numRefresh = 0
            totalSuccess = true
            
            refresh(formId: form.id, {success in
                // Assumes this callback is invoked on the UI thread, so no need for synctonization
                self.numRefresh += 1
                self.totalSuccess = self.totalSuccess && success
                
                if (self.numRefresh >= self.forms.count) {
                    callback?(self.totalSuccess)
                }
            })
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        try? encoder.encode(self.forms).write(to: URL(fileURLWithPath: SecondHand.cacheFile), options: [.atomic])
    }
    
    struct Form : Codable {
        let id: Int
        let status: Status
        let items: Array<SecondHand.Item>
        
        struct Status :Codable {
            let id: Int
            let text: String
            
            func isClosed() -> Bool {
                return id == 3
            }
        }
    }
    
    struct Item : Codable {
        let id: Int
        let formId: Int
        let indexInForm: Int
        let description: String
        let price: Int
        let status: Status
        let category: Category
        
        struct Status : Codable {
            let id: Id
            let text: String
            
            enum Id : Int, Codable {
                case ready = 1
                case created
                case sold
                case missing
                case withdrawn
            }
        }
        
        struct Category : Codable {
            let id: Int
            let text: String
        }
    }
}
