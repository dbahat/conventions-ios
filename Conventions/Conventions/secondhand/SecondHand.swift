//
//  SecondHandForms.swift
//  Conventions
//
//  Created by David Bahat on 30/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class SecondHand {

    private static let fileName = Convention.name + "SecondHand.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + "1_" + fileName;
    
    private let refreshUrl = "https://calm-dawn-51174.herokuapp.com/getMultipleItemsByForm?itemFormIds="
    var forms: Array<SecondHand.Form> = [] {
        didSet {
            self.save()
        }
    }
    
    init() {
        if let cachedForms = try? Data(contentsOf: URL(fileURLWithPath: SecondHand.cacheFile)) {
            if let forms = SecondHand.parse(cachedForms) {
                self.forms = forms
            }
        }
    }
        
    func refresh(_ callback: ((Bool) -> Void)?) {

        let formIds = forms.map({String($0.id)}).joined(separator: ",")
        let url = URL(string: refreshUrl + formIds)!
        
        URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) -> Void in
            guard
                let rawForms = data,
                let forms = SecondHand.parse(rawForms)
                else {
                    DispatchQueue.main.async {
                        callback?(false)
                    }
                    return
            }
            
            DispatchQueue.main.async {
                self.forms = forms
                callback?(true)
            }
        }).resume()
        
    }
    
    func save() {
        if let serializedData = try? JSONSerialization.data(
            withJSONObject: toJson(),
            options: JSONSerialization.WritingOptions.prettyPrinted) {
            try? serializedData.write(to: URL(fileURLWithPath: SecondHand.cacheFile), options: [.atomic])
        }
    }
    
    private static func parse(_ data: Data) -> Array<SecondHand.Form>? {
        guard
            let deserializedSecondHandData = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>,
            let forms = deserializedSecondHandData?["forms"] as? Array<Dictionary<String, AnyObject>>
        else {
                print("Failed to deserialize second hand forms")
                return nil
        }
        
        return forms.map({SecondHand.Form.parse(json: $0)}).filter({$0 != nil}).map({$0!})
    }
    
    private func toJson() -> Dictionary<String, AnyObject> {
        return [
            "forms": forms.map({$0.toJson()}) as AnyObject
        ]
    }
    
    class Form {
        private let refreshUrl = "https://calm-dawn-51174.herokuapp.com/getAllItemsByForm?itemFormId="
     
        var id: Int
        var items: Array<SecondHand.Item> = []
        var closed = false
        
        init(id: Int) {
            self.id = id
        }
        
        func refresh(_ callback: ((Bool) -> Void)?) {
            let url = URL(string: refreshUrl + String(id))!
            
            URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) -> Void in
                guard
                    let rawItems = data,
                    let form = SecondHand.Form.parse(contractData: rawItems)
                else {
                    DispatchQueue.main.async {
                        callback?(false)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.id = form.id
                    self.items = form.items
                    self.closed = form.closed
                    
                    callback?(true)
                }
            }).resume()
        }
        
        static func parse(contract: NSArray) -> SecondHand.Form? {
            var result: Array<SecondHand.Item> = []
            
            for rawItem in contract {
                guard let item = rawItem as? Dictionary<String, AnyObject> else {
                    print("Got invalid second hand item. Skipping")
                    continue
                }
                
                result.append(SecondHand.Item(
                    id: item["formId"] as? String ?? "",
                    type: (item["itemCategory"] as? String ?? "").stringByDecodingHTMLEntities,
                    price: item["price"] as? Int,
                    number: item["formItemNumber"] as? Int,
                    status: Item.Status.parse(item["itemStatus"] as? String ?? ""),
                    formClosed: ((item["formStatus"] as? String ?? "") == "closed"),
                    description: (item["itemDescription"] as? String ?? "").stringByDecodingHTMLEntities,
                    formId:Int(item["formNumber"] as? String ?? "0")))
            }
            
            if result.count == 0 {
                return nil
            }
            
            let form = SecondHand.Form(id: result.first!.formId!)
            form.items = result
            form.closed = result.first!.formClosed ?? false
            return form
        }
        
        static func parse(contractData: Data) -> SecondHand.Form? {
            guard let deserializedItems =
                try? JSONSerialization.jsonObject(with: contractData, options: []) as? NSArray,
                let items = deserializedItems
                else {
                    print("Failed to deserialize second hand items")
                    return nil
            }
            
            return SecondHand.Form.parse(contract: items)
        }
        
        static func parse(json: Dictionary<String, AnyObject>) -> SecondHand.Form? {
            guard
                let formId = json["id"] as? Int,
                let closed = json["closed"] as? Bool,
                let rawItems = json["items"] as? Array<Dictionary<String, AnyObject>>
                else {
                    print("Got invalid second hand form. Skipping")
                    return nil
            }
            
            let form = SecondHand.Form(id: formId)
            form.closed = closed
            form.items = rawItems
                .map({SecondHand.Item.parse(json: $0)})
                .filter {$0 != nil}
                .map {$0!}
            
            return form
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "id": id as AnyObject,
                "closed": closed as AnyObject,
                "items": items.map({$0.toJson()}) as AnyObject,
            ]
        }
    }
    
    class Item {
        let id: String
        let type: String
        let description: String
        let price: Int?
        let number: Int?
        let status: Status
        
        // Note - Form related info is represented in the server contract due to technical reasons.
        // In the model we store the data on the Form object. Keeping these two members here without
        // serializing them just since we don't currently do any model/contract object seperation.
        let formClosed: Bool?
        let formId: Int?
        
        enum Status {
            case sold
            case notSold
            case missing
            
            func format() -> String {
                switch self {
                case .sold:
                    return "sold"
                case .missing:
                    return "missing"
                default:
                    return "notSold"
                }
            }
            
            static func parse(_ string: String) -> Status {
                switch string {
                case "sold":
                    return .sold
                case "missing":
                    return .missing
                default:
                    return .notSold
                }
            }
        }

        convenience init(id: String, type: String, price: Int?, number: Int?, status: Status, description: String) {
            self.init(id: id, type: type, price: price, number: number, status: status, formClosed: nil, description: description, formId: nil)
        }
        
        init(id: String, type: String, price: Int?, number: Int?, status: Status, formClosed: Bool?, description: String, formId: Int?) {
            self.id = id
            self.type = type
            self.price = price
            self.status = status
            self.number = number
            self.formClosed = formClosed
            self.description = description
            self.formId = formId
        }
        
        static func parse(json: Dictionary<String, AnyObject>) -> SecondHand.Item? {
            guard
                let id = json["id"] as? String,
                let type = json["type"] as? String,
                let price = json["price"] as? Int,
                let status = json["status"] as? String,
                let number = json["number"] as? Int,
                let description = json["description"] as? String
            else {
                    print("Got invalid second hand form. Skipping")
                    return nil
            }
            
            return SecondHand.Item(id: id, type: type, price: price, number: number, status: Status.parse(status), description: description)
        }
        
        func toJson() -> Dictionary<String, AnyObject> {
            return [
                "id": id as AnyObject,
                "type": type as AnyObject,
                "price": (price ?? 0) as AnyObject,
                "status": status.format() as AnyObject,
                "number": (number ?? 0) as AnyObject,
                "description": description as AnyObject
            ]
        }
    }
}
