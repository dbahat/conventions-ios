//
//  UserTicketsRetriever.swift
//  Conventions
//
//  Created by Bahat, David on 21/09/2019.
//  Copyright © 2019 Amai. All rights reserved.
//

import Foundation

class UserTicketsRetriever {
    
    private let issuer = URL(string: "https://sso.sf-f.org.il/auth/realms/sf-f")!
    private let clientId = "con_apps_v2"
    private let redirectURI = URL(string: "sf-f.conventions://oauth2redirect/sff")!
    
    private static let userTicketsApi = URL(string: "https://api.sf-f.org.il/program/cod3/events_per_user_sso?slug=" + Convention.name)!
    private static let userIdApi = URL(string: "https://api.sf-f.org.il/program/cod3/get_user_id_sso?slug=" + Convention.name)!
    private static let qrApi = "https://api.sf-f.org.il/cons/qr/byToken"
    
    func retrieve(caller: UIViewController, callback: @escaping (_ result: Tickets, _ error: Error?) -> Void) {
        
        if
            let data = UserDefaults.standard.object(forKey: "AuthState") as? Data,
            let authState = try? NSKeyedUnarchiver.unarchivedObject(ofClass: OIDAuthState.self, from: data) {
                authState.performAction(freshTokens: {accessToken, idToken, error in
                    if error != nil {
                        callback(Tickets(), error)
                        return
                    }
                    
                    if
                            let unwrappedToken = idToken,
                            let parsedIdToken = OIDIDToken.init(idTokenString: unwrappedToken),
                            let email = parsedIdToken.claims["email"] as? String,
                            let token = accessToken
                    {
                        self.fetchTicketsAndQr(token: token, email: email, callback: callback)
                        return
                    }
                })
        } else {
            interactiveLogin(caller: caller, callback: { authState, error in
                if error != nil {
                    callback(Tickets(), error)
                    return
                }
                
                guard
                    let authState = authState,
                    let tokenResponse = authState.lastTokenResponse,
                    let idToken = tokenResponse.idToken,
                    let parsedIdToken = OIDIDToken.init(idTokenString: idToken),
                    let email = parsedIdToken.claims["email"] as? String,
                    let token = tokenResponse.accessToken
                else {
                    callback(Tickets(), error)
                    return
                }
                
                self.fetchTicketsAndQr(token: token, email: email, callback: callback)
            })
        }
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "AuthState")
    }
    
    private func interactiveLogin(caller: UIViewController, callback: @escaping (_ result: OIDAuthState?, _ error: Error?) -> Void) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in

            if error != nil {
                callback(nil, error)
                return
            }
            
            guard
                let config = configuration,
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                callback(nil, error)
                return
            }
            
            let request = OIDAuthorizationRequest(configuration: config,
                                                  clientId: self.clientId,
                                                  clientSecret: nil,
                                                  scopes: [OIDScopeOpenID, OIDScopeProfile],
                                                  redirectURL: self.redirectURI,
                                                  responseType: OIDResponseTypeCode,
                                                  additionalParameters: ["prompt":"login"])
            
            appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: caller) { authState, error in
                if let state = authState,
                   let data = try? NSKeyedArchiver.archivedData(withRootObject: state, requiringSecureCoding: true)
                {
                    UserDefaults.standard.set(data, forKey: "AuthState")
                }

                callback(authState, error)
            }
        }
    }
    
    private func fetchTicketsAndQr(token: String, email: String, callback: @escaping (_ result: Tickets, _ error: Error?) -> Void) {
        self.sendRequest(url: UserTicketsRetriever.userTicketsApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
            if error != nil {
                callback(Tickets(), error)
                return
            }
            
            guard
                let unwrappedData = data,
                let tickets = self.deserialize(unwrappedData)
            else {
                callback(Tickets(), error)
                return;
            }

            let intTickets = tickets.filter({Int($0) != nil}).map({Int($0)!})

            self.sendRequest(url: UserTicketsRetriever.userIdApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
                // ignoring userId fetch failures. Since there are valid cases where it can be missing (user defined but missing initial login)
                let userId = data != nil ? String(data: data!, encoding: .utf8)! : ""
                
                let qrApi = URL(string: UserTicketsRetriever.qrApi + "?token=\(token)&email=\(email)")!
                self.sendRequest(url: qrApi, method: "GET", body: nil, completionHandler: { (data, error) in
                    if error != nil {
                        callback(Tickets(), error)
                        return
                    }
                    
                    guard
                        let qrData = data
                    else {
                        callback(Tickets(), error)
                        return;
                    }
                    
                    callback(Tickets(userId: userId, eventIds: intTickets, qrData: qrData, email: email), error)
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
            let sessionConfig =  URLSessionConfiguration.default
            sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(oauthToken)"]
            session = URLSession(configuration: sessionConfig)
        }
        
        session.dataTask(with:request , completionHandler:{(data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(nil, NSError())
                    return
                }
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 400 {
                    completionHandler(nil, NSError(domain:"", code:httpResponse.statusCode, userInfo:nil))
                    return
                }
                if error != nil {
                    completionHandler(nil, error)
                    return
                }
                if httpResponse.statusCode == 400 {
                    completionHandler("".data(using: .utf8), nil)
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
