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
    private let redirectURI = URL(string: "SF-F.Conventions:/oauth2redirect/sff")!
    
    private static let userTicketsApi = URL(string: "https://api.sf-f.org.il/program/cod3/events_per_user_sso?slug=" + Convention.name)!
    private static let userIdApi = URL(string: "https://api.sf-f.org.il/program/cod3/get_user_id_sso?slug=" + Convention.name)!
    private static let qrApi = URL(string: "https://api.sf-f.org.il/cons/qr/login")!
    
    func retrieve(caller: UIViewController, callback: @escaping (_ result: Tickets, _ error: Error?) -> Void) {
        
        if
            let data = UserDefaults.standard.object(forKey: "AuthState") as? Data,
            let authState = try? NSKeyedUnarchiver.unarchivedObject(ofClass: OIDAuthState.self, from: data) {
                authState.performAction(freshTokens: {accessToken, idToken, error in
                    if
                            let unwrappedToken = idToken,
                            let parsedIdToken = OIDIDToken.init(idTokenString: unwrappedToken),
                            let email = parsedIdToken.claims["email"] as? String
                    {
                        self.fetchTicketsAndQr(token: accessToken, email: email, callback: callback)
                        return
                    }
                })
        } else {
            interactiveLogin(caller: caller, callback: { authState, error in
                guard
                    let authState = authState,
                    let tokenResponse = authState.lastTokenResponse,
                    let idToken = tokenResponse.idToken,
                    let parsedIdToken = OIDIDToken.init(idTokenString: idToken),
                    let email = parsedIdToken.claims["email"] as? String
                else {
                    callback(Tickets(), error)
                    return
                }
                
                self.fetchTicketsAndQr(token: tokenResponse.accessToken, email: email, callback: callback)
            })
        }
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "AuthState")
    }
    
    private func interactiveLogin(caller: UIViewController, callback: @escaping (_ result: OIDAuthState?, _ error: Error?) -> Void) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in

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
    
    private func fetchTicketsAndQr(token: String?, email: String, callback: @escaping (_ result: Tickets, _ error: Error?) -> Void) {
        self.sendRequest(url: UserTicketsRetriever.userTicketsApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
            guard
                let unwrappedData = data,
                let tickets = self.deserialize(unwrappedData)
            else {
                callback(Tickets(), error)
                return;
            }

            let intTickets = tickets.filter({Int($0) != nil}).map({Int($0)!})

            self.sendRequest(url: UserTicketsRetriever.userIdApi, method: "GET", token: token, body: nil, completionHandler: { (data, error) in
                guard
                    let unwrappedData = data,
                    let userId = String(data: unwrappedData, encoding: .utf8)
                else {
                    callback(Tickets(), error)
                    return;
                }
                
                let qrApi = UserTicketsRetriever.qrApi.appendingPathComponent(email)
                self.sendRequest(url: qrApi, method: "GET", body: nil, completionHandler: { (data, error) in
                    guard
                        let qrData = data
                    else {
                        callback(Tickets(userId: userId, eventIds: intTickets, qrData: nil, email: email), error)
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
            //request.setValue("Bearer \(oauthToken)", forHTTPHeaderField: "Authorization")
            let sessionConfig =  URLSessionConfiguration.default
            sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(oauthToken)"]
            session = URLSession(configuration: sessionConfig)
        }
        
        session.dataTask(with:request , completionHandler:{(data, response, error) -> Void in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode != 200) || (error != nil) {
                    completionHandler(nil, error)
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
