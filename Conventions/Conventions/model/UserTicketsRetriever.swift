//
//  UserTicketsRetriever.swift
//  Conventions
//
//  Created by Bahat, David on 21/09/2019.
//  Copyright © 2019 Amai. All rights reserved.
//

import Foundation

class UserTicketsRetriever {
    private static let userTicketsApi = URL(string: "https://api.sf-f.org.il/program/events_per_user.php?slug=" + Convention.name)!
    private static let userIdApi = URL(string: "https://api.sf-f.org.il/program/get_user_id.php?slug=" + Convention.name)!
    private static let qrApi = URL(string: "https://api.sf-f.org.il/cons/qr/login")!
    
    enum Error {
        case badUsername,badPassword,unknown
    }
    
    func retrieve(user: String, password: String, callback: ((_ result: Tickets, _ error: Error?) -> Void)?) {
        
        let escapedUser = user.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestBody = String(format: "email=%@&pass=%@", escapedUser, escapedPassword).data(using: .utf8)
        
        sendRequest(url: UserTicketsRetriever.userTicketsApi, method: "POST", body: requestBody, completionHandler: { (data, error) in
            guard
                let unwrappedData = data,
                let tickets = self.deserialize(unwrappedData)
            else {
                callback?(Tickets(), error ?? .unknown)
                return;
            }

            let intTickets = tickets.filter({Int($0) != nil}).map({Int($0)!})

            self.sendRequest(url: UserTicketsRetriever.userIdApi, method: "POST", body: requestBody, completionHandler: { (data, error) in
                guard
                    let unwrappedData = data,
                    let userId = String(data: unwrappedData, encoding: .utf8)
                else {
                    callback?(Tickets(), error)
                    return;
                }
                
                let qrApi = UserTicketsRetriever.qrApi.appendingPathComponent(user)
                self.sendRequest(url: qrApi, method: "GET", body: nil, completionHandler: { (data, error) in
                    guard
                        let qrData = data
                    else {
                        callback?(Tickets(userId: userId, eventIds: intTickets, qrData: nil), error)
                        return;
                    }
                    
                    callback?(Tickets(userId: userId, eventIds: intTickets, qrData: qrData), error)
                })
            })
        })
    }
    
    private func sendRequest(url: URL, method: String, body: Data?, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
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
    
    private func deserialize(_ data: Data) -> Array<String>? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? Array<String>
        } catch {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
}
