//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            let loginButton = FBSDKLoginButton();
            loginButton.center = view.center;
            loginButton.delegate = self;
            loginButton.readPermissions = ["public_profile"];
            view.addSubview(loginButton);
            return;
        }
        
        refreshUpdates();
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (result.isCancelled) {
            print("BAD");
            return;
        }
        
        print("OK");
        refreshUpdates();
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true;
    }
    
    func refreshUpdates() {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": ""]); // /harucon.org.il/posts
        request.startWithCompletionHandler({ connection, result, error in
            print(result);
        });
    }
}
