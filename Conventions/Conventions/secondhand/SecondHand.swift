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

    // Used to count the number of downloaded forms during refresh
    private var numRefresh = 0
    private var totalSuccess = true
    
    var cache = Cache(forms: [], lastRefresh: nil)
    var forms: Array<SecondHand.Form> {
        get {
            return cache.forms
        }
    }
    
    init() {
        let jsonDecoder = JSONDecoder()
        if
            let cacheJson = try? Data(contentsOf: URL(fileURLWithPath: SecondHand.cacheFile)),
            let cache = try? jsonDecoder.decode(Cache.self, from: cacheJson) {
            self.cache = cache
        }
    }
    
    func refresh(formId: Int, _ callback: ((Bool) -> Void)?) {
        let url = URL(string: SecondHand.refreshUrl + String(formId))!
        
        URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) -> Void in

            guard
                let jsonData = data,
                let forms = try? JSONDecoder().decode(Array<Form>.self, from: jsonData)
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
                    self.cache.forms[formToRemove] = forms.first!
                } else {
                    self.cache.forms.append(forms.first!)
                }

                self.cache.lastRefresh = Date.now()
                self.save()
                print("downloaded form " + String(formId))
                
                callback?(true)
            }
        }).resume()
    }
        
    func refresh(force: Bool, _ callback: ((Bool) -> Void)?) {
        
        if let lastRefresh = cache.lastRefresh {
            if !force && lastRefresh.addMinutes(1) >= Date.now() {
                print("Second hand cache was already updated less then an hour ago. Skipping refresh")
                callback?(true)
                return
            }
        }
        
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
    
    func remove(formId: Int) {
        if let formIndex = forms.index(where: {$0.id == formId}) {
            cache.forms.remove(at: formIndex)
            save()
        }
    }
    
    private func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        try? encoder.encode(self.cache).write(to: URL(fileURLWithPath: SecondHand.cacheFile), options: [.atomic])
    }
    
    struct Cache : Codable {
        var forms: Array<SecondHand.Form>
        var lastRefresh: Date?
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
