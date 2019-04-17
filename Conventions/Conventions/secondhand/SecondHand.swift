//
//  SecondHandForms.swift
//  Conventions
//
//  Created by David Bahat on 30/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class SecondHand {
    private static let refreshUrl = "https://api.sf-f.org.il/yad2/form?formIds="
    private static let fileName = Convention.name + "SecondHand.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "1_" + fileName;
    
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
    
    func refresh(formIds: Array<Int>, _ callback: ((Bool) -> Void)?) {
        
        if formIds.count == 0 {
            callback?(true)
            return
        }
        
        let formIdsString = formIds
            .map{String($0)}
            .joined(separator: ",")
        
        let url = URL(string: SecondHand.refreshUrl + formIdsString)!
        
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
                // The server returns an empty array if no matching forms were found
                if (forms.count == 0) {
                    callback?(false)
                    return
                }
                
                for form in forms {
                    print("downloaded form " + String(form.id))
                    
                    // Remove the form if it already existed
                    if let formToRemove = self.forms.index(where: ({$0.id == form.id})) {
                        self.cache.forms[formToRemove] = form
                    } else {
                        self.cache.forms.append(form)
                    }
                }

                self.cache.lastRefresh = Date.now()
                self.save()
                
                callback?(true)
            }
        }).resume()
    }
    
    func refresh(formId: Int, _ callback: ((Bool) -> Void)?) {
        refresh(formIds: [formId], callback)
    }
        
    func refresh(force: Bool, _ callback: ((Bool) -> Void)?) {
        
        if let lastRefresh = cache.lastRefresh {
            if !force && lastRefresh.addHours(1) >= Date.now() {
                print("Second hand cache was already updated less then an hour ago. Skipping refresh")
                callback?(true)
                return
            }
        }
        
        refresh(formIds: forms.map({$0.id}), callback)
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
                case created = 1
                case ready
                case sold
                case missing
                case returned
            }
        }
        
        struct Category : Codable {
            let id: Int
            let text: String
        }
    }
}
