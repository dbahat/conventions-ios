//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    private let updateCellTopLayoutSize: CGFloat = 19
    private let updateCellMargins: CGFloat = 20
    
    @IBOutlet private weak var noUpdatesFoundLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    private let tableViewController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: String(UpdateTableViewCell), bundle: nil), forCellReuseIdentifier: String(UpdateTableViewCell))
        
        if Convention.instance.updates.getAll().count > 0 {
            noUpdatesFoundLabel.hidden = true
        }
        
        addRefreshControl()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        Convention.instance.updates.markAllAsRead()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Convention.instance.updates.getAll().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UpdateTableViewCell), forIndexPath: indexPath) as! UpdateTableViewCell
        cell.setUpdate(Convention.instance.updates.getAll()[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let updateText = Convention.instance.updates.getAll()[indexPath.row].text;
        let attrText = NSAttributedString(string: updateText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)])
        return attrText.boundingRectWithSize(CGSize(width: self.tableView.frame.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height + updateCellMargins + updateCellTopLayoutSize
    }
    
    // MARK: - Private methods
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    func refresh()
    {
        // Mark all current updates as old so new events will appear with different UI
        Convention.instance.updates.markAllAsRead()
        
        Convention.instance.updates.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing()
            
            GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("PullToRefresh",
                action: "RefreshUpdates",
                label: "",
                value: success ? 1 : 0)
                .build() as [NSObject: AnyObject]);
            
            if !success {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.Middle, superView: self.view).show()
                return
            }
            
            if Convention.instance.updates.getAll().count == 0 {
                self.noUpdatesFoundLabel.hidden = false
            }
            
            self.tableView.reloadData()
        });
    }
    
    private func addRefreshControl() {
        // Adding a tableViewController for hosting a UIRefreshControl.
        // Without a table controller the refresh control causes weird UI issues (e.g. wrong handling of
        // sticky section headers).
        tableViewController.tableView = tableView
        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.tintColor = UIColor(hexString: "#7a3d59")
        tableViewController.refreshControl?.addTarget(self, action: #selector(UpdatesViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        addChildViewController(tableViewController)
        tableViewController.didMoveToParentViewController(self)
    }
}
