//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, FBSDKLoginButtonDelegate, UITableViewDataSource, UITableViewDelegate {

    let updateCellTopLayoutSize: CGFloat = 19;
    let updateCellMargins: CGFloat = 20;
    
    var updates: Array<Update> = [];
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginButtonContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.registerNib(UINib(nibName: String(UpdateTableViewCell), bundle: nil), forCellReuseIdentifier: String(UpdateTableViewCell));
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            facebookLoginButton.delegate = self;
            facebookLoginButton.readPermissions = ["public_profile"];
            tableView.hidden = true;
            return;
        } else {
            loginButtonContainer.hidden = true;
        }
        
        refreshUpdates();
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData();
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (result.isCancelled) {
            return;
        }
        
        loginButtonContainer.hidden = true;
        tableView.hidden = false;
        refreshUpdates();
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true;
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UpdateTableViewCell), forIndexPath: indexPath) as! UpdateTableViewCell;
        cell.setUpdate(updates[indexPath.row])
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let updateText = self.updates[indexPath.row].text;
        let attrText = NSAttributedString(string: updateText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)]);
        return attrText.boundingRectWithSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + updateCellMargins + updateCellTopLayoutSize;
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - Private methods
    
    func refreshUpdates() {
        let request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: nil);
        // TODO - Add 'since' param for 2 days ago in unix epoch time
        request.startWithCompletionHandler({ connection, result, error in
            self.updates = self.parseFacebookResult(result)
                .sort({ $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 });
            print("Downloaded updates ", self.updates.count);
            self.tableView.reloadData();
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
