//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class UpdatesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate let updateCellTopLayoutSize: CGFloat = 19
    fileprivate let updateCellMargins: CGFloat = 20
    
    @IBOutlet fileprivate weak var noUpdatesFoundLabel: UILabel!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // Keeping the tableController as a child so we'll be able to add other subviews to the current
    // screen's view controller (e.g. snackbarView)
    fileprivate let tableViewController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: UpdateTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UpdateTableViewCell.self))
        
        if Convention.instance.updates.getAll().count > 0 {
            noUpdatesFoundLabel.isHidden = true
        }
        
        addRefreshControl()
        
        Convention.instance.updates.refresh({success in
            if Convention.instance.updates.getAll().count == 0 {
                self.noUpdatesFoundLabel.isHidden = false
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Convention.instance.updates.markAllAsRead()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Convention.instance.updates.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UpdateTableViewCell.self), for: indexPath) as! UpdateTableViewCell
        cell.setUpdate(Convention.instance.updates.getAll()[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let updateText = Convention.instance.updates.getAll()[indexPath.row].text;
        let attrText = NSAttributedString(string: updateText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        return attrText.boundingRect(with: CGSize(width: self.tableView.frame.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height + updateCellMargins + updateCellTopLayoutSize
    }
    
    // MARK: - Private methods
    
    // Note - This method is accessed by the refreshControl using introspection, and should not be private
    func refresh()
    {
        // Mark all current updates as old so new events will appear with different UI
        Convention.instance.updates.markAllAsRead()
        
        Convention.instance.updates.refresh({success in
            self.tableViewController.refreshControl?.endRefreshing()
            
            GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "PullToRefresh",
                action: "RefreshUpdates",
                label: "",
                value: success ? 1 : 0)
                .build() as! [AnyHashable: Any]);
            
            if !success {
                TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.middle, superView: self.view).show()
                return
            }
            
            if Convention.instance.updates.getAll().count == 0 {
                self.noUpdatesFoundLabel.isHidden = false
            }
            
            self.tableView.reloadData()
        });
    }
    
    fileprivate func addRefreshControl() {
        // Adding a tableViewController for hosting a UIRefreshControl.
        // Without a table controller the refresh control causes weird UI issues (e.g. wrong handling of
        // sticky section headers).
        tableViewController.tableView = tableView
        tableViewController.refreshControl = UIRefreshControl()
        tableViewController.refreshControl?.tintColor = UIColor(hexString: "#7a3d59")
        tableViewController.refreshControl?.addTarget(self, action: #selector(UpdatesViewController.refresh), for: UIControlEvents.valueChanged)
        addChildViewController(tableViewController)
        tableViewController.didMove(toParentViewController: self)
    }
}
