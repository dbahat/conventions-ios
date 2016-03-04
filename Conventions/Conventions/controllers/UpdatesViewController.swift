//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    @IBOutlet weak var loginButtonContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            facebookLoginButton.delegate = self;
            facebookLoginButton.readPermissions = ["public_profile"];
            return;
        } else {
            loginButtonContainer.hidden = true;
        }
        
        refreshUpdates();
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (result.isCancelled) {
            return;
        }
        
        loginButtonContainer.hidden = true;
        refreshUpdates();
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true;
    }
    
    func refreshUpdates() {
        let request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: nil);
        // TODO - Add 'since' param for 2 days ago in unix epoch time
        request.startWithCompletionHandler({ connection, result, error in
            let updates = self.parseFacebookResult(result);
            print(updates);
        });
    }
    
    private func parseFacebookResult(result: AnyObject!) -> Array<Update> {
        var updates = Array<Update>();
        guard let resultEvents = result["data"] as? [AnyObject] else {return updates;}
        for event in resultEvents {
            guard let id = event["id"] as? String else {continue;};
            guard let message = event["message"] as? String else {continue;}
            guard let createdTime = event["created_time"] as? String else {continue;}
            guard let parsedDate = NSDate.parse(createdTime, dateFormat: "yyyy-MM-dd'T'HH:mm:ssz") else {continue;}
            
            updates.append(Update(id: id, text: message, date: parsedDate));
        }
        
        return updates;
    }
}
