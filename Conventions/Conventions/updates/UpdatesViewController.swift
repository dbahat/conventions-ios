//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, FBSDKLoginButtonDelegate, UITableViewDataSource, UITableViewDelegate {

    private let updateCellTopLayoutSize: CGFloat = 19;
    private let updateCellMargins: CGFloat = 20;
    
    @IBOutlet private weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet private weak var loginButtonContainer: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
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
        
        refreshUpdates(nil);
        
        tableView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);

    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData();
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
        Convention.instance.updates = Convention.instance.updates.map({update in
            update.isNew = false
            return update
        });
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
        refreshUpdates(nil);
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
        return Convention.instance.updates.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UpdateTableViewCell), forIndexPath: indexPath) as! UpdateTableViewCell;
        cell.setUpdate(Convention.instance.updates[indexPath.row])
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let updateText = Convention.instance.updates[indexPath.row].text;
        let attrText = NSAttributedString(string: updateText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)]);
        return attrText.boundingRectWithSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + updateCellMargins + updateCellTopLayoutSize;
    }
    
    // MARK: - Private methods
    
    func refresh(sender:AnyObject)
    {
        refreshUpdates({
            self.tableView.reloadData();
            self.refreshControl.endRefreshing();
        })
    }
    
    func refreshUpdates(callback: (() -> Void)?) {
        var request : FBSDKGraphRequest;
        if let latestUpdateTime = Convention.instance.updates
            .maxElement({$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970}) {
                request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: ["since": (latestUpdateTime.date.timeIntervalSince1970)]);
        } else {
            request = FBSDKGraphRequest(graphPath: "/harucon.org.il/posts", parameters: nil);
        }

        request.startWithCompletionHandler({ connection, result, error in
            let updates = self.parseFacebookResult(result)
                .sort({ $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 });
            print("Downloaded updates ", Convention.instance.updates.count);
            callback?();
            
            // Using main thread for syncronizing access to updates
            dispatch_async(dispatch_get_main_queue()) {
                Convention.instance.updates.appendContentsOf(updates);
                self.tableView.reloadData();
            }
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
