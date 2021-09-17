//
//  UserTicketsRetriever.swift
//  Conventions
//
//  Created by Bahat, David on 21/09/2019.
//  Copyright © 2019 Amai. All rights reserved.
//

import Foundation

class UserTicketsRetriever {
    private static let getTokenApi = URL(string: "https://sso.sf-f.org.il/auth/realms/sf-f/protocol/openid-connect/token")!
    private static let userTicketsApi = URL(string: "https://api.sf-f.org.il/program/cod3/events_per_user_sso?slug=" + Convention.name)!
    private static let userIdApi = URL(string: "https://api.sf-f.org.il/program/cod3/get_user_id_sso?slug=" + Convention.name)!
    private static let qrApi = URL(string: "https://api.sf-f.org.il/cons/qr/login")!
    
    private static let clientId = "con_apps"
    private static let clientSecret = "d1f36c7e-83c1-4008-843c-8853f8e3c8ea" // hardcoded in the app since the server only supports password grant type
    
    enum Error {
        case badUsername,badPassword,unknown
    }
    
    func retrieve(user: String, password: String, callback: ((_ result: Tickets, _ error: Error?) -> Void)?) {
        
        let escapedUser = user.addingPercentEncoding(withAllowedCharacters: .letters)!
        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .letters)!
        let requestBody = String(format: "grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@", UserTicketsRetriever.clientId, UserTicketsRetriever.clientSecret, escapedUser, escapedPassword)
        
        sendRequest(url: UserTicketsRetriever.getTokenApi, method: "POST", body: requestBody.data(using: .utf8), completionHandler: { (data, error) in
            guard
                let unwrappedData = data,
                let token = self.deserializeToken(unwrappedData)
            else {
                callback?(Tickets(), error ?? .unknown)
                return;
            }
            
            self.sendRequest(url: UserTicketsRetriever.userTicketsApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
                guard
                    let unwrappedData = data,
                    let tickets = self.deserialize(unwrappedData)
                else {
                    callback?(Tickets(), error ?? .unknown)
                    return;
                }

                let intTickets = tickets.filter({Int($0) != nil}).map({Int($0)!})

                self.sendRequest(url: UserTicketsRetriever.userIdApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
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
            
        })
    }
    
    private func sendRequest(url: URL, method: String, body: Data?, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        sendRequest(url: url, method: method, token: nil, body: body, completionHandler: completionHandler)
    }
    
    private func sendRequest(url: URL, method: String, token: String?, body: Data?, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        var request = URLRequest(url: url)
        var session = URLSession.shared
        request.httpMethod = method
        request.httpBody = body
        if let oauthToken = token {
            //request.setValue("Bearer \(oauthToken)", forHTTPHeaderField: "Authorization")
            let sessionConfig =  URLSessionConfiguration.default
            sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(oauthToken)"]
            session = URLSession(configuration: sessionConfig)
        }
        
        session.dataTask(with:request , completionHandler:{(data, response, error) -> Void in
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
    
    private func deserializeToken(_ data: Data) -> String? {
        do {
            let token = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? Dictionary<String, Any>
            return token?["access_token"] as? String
        } catch {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
}
