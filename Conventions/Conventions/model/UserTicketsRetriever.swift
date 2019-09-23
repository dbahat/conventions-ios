//
//  UserTicketsRetriever.swift
//  Conventions
//
//  Created by Bahat, David on 21/09/2019.
//  Copyright © 2019 Amai. All rights reserved.
//

import Foundation

class UserTicketsRetriever {
    private static let userTicketsApi = URL(string: "https://api.sf-f.org.il/program/events_per_user.php?slug=icon2019")!;
    private static let userIdApi = URL(string: "https://api.sf-f.org.il/program/get_user_id.php?slug=icon2019")!;
    
    enum Error {
        case badUsername,badPassword,unknown
    }
    
    func retrieve(user: String, password: String, callback: ((_ result: Tickets, _ error: Error?) -> Void)?) {

        let escapedUser = user.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestBody = String(format: "email=%@&pass=%@", escapedUser, escapedPassword).data(using: .utf8)
        
        postRequest(url: UserTicketsRetriever.userTicketsApi, body: requestBody, completionHandler: { (data, error) in
            guard
                let unwrappedData = data,
                let tickets = self.deserialize(unwrappedData)
            else {
                callback?(Tickets(), error)
                return;
            }
            
            self.postRequest(url: UserTicketsRetriever.userIdApi, body: requestBody, completionHandler: { (data, error) in
                guard
                    let unwrappedData = data,
                    let userId = String(data: unwrappedData, encoding: .utf8)
                else {
                    callback?(Tickets(userId: "", eventIds: tickets), error)
                    return;
                }
                callback?(Tickets(userId: userId, eventIds: tickets), error)
            })
        })
    }
    
    private func postRequest(url: URL, body: Data?, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        URLSession.shared.dataTask(with:request , completionHandler:{(data, response, error) -> Void in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    switch httpResponse.statusCode {
                    case 401:
                        completionHandler(nil, .badPassword)
                        return
                    case 400:
                        completionHandler(nil, .badUsername)
                        return
                    default:
                        completionHandler(nil, .unknown)
                    }
                    
                }
                
                if error != nil {
                    completionHandler(data, .unknown)
                    return
                }
                
                completionHandler(data, nil)
            }
        }).resume();
    }
    
    private func deserialize(_ data: Data) -> Array<Int>? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Int>
        } catch {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
}
