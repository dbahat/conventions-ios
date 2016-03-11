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
        }
        
        loginButtonContainer.hidden = true;
        
        tableView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged);

    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData();
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
        Convention.instance.updates.markAllAsRead();
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (result.isCancelled) {
            return;
        }
        
        loginButtonContainer.hidden = true;
        tableView.hidden = false;
        refresh();
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
        return Convention.instance.updates.getAll().count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UpdateTableViewCell), forIndexPath: indexPath) as! UpdateTableViewCell;
        cell.setUpdate(Convention.instance.updates.getAll()[indexPath.row])
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let updateText = Convention.instance.updates.getAll()[indexPath.row].text;
        let attrText = NSAttributedString(string: updateText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)]);
        return attrText.boundingRectWithSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + updateCellMargins + updateCellTopLayoutSize;
    }
    
    // MARK: - Private methods
    
    func refresh()
    {
        // Mark all current updates as old so new events will appear with different UI
        Convention.instance.updates.markAllAsRead();
        
        Convention.instance.updates.refresh({success in
            self.refreshControl.endRefreshing();
            
            if (!success) {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.Middle, superView: self.view).show();
                return;
            }
            
            self.tableView.reloadData();
        });
    }
}
