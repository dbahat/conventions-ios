//
//  MoreInfoViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class MoreInfoViewController : BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var items = [
        Item(name: "מפת המתחם", imageId: "MenuMap", viewControllerId: "MapViewController"),
        Item(name: "דרכי הגעה", imageId: "MenuArrivalMethods", viewControllerId: "ArrivalMethodsViewController"),
        Item(name: "הטבות ושותפויות", imageId: "MenuDiscounts", viewControllerId: "DiscountsViewController"),
        Item(name: "אודות הכנס", imageId: "MenuAbout", viewControllerId: "AboutViewController"),
        Item(name: "נגישות", imageId: "MenuAccessability", viewControllerId: "AccessabilityViewController"),
        Item(name: "הגדרות", imageId: "MenuSettings", viewControllerId: "NotificationSettingsViewController"),
    ]
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Convention.instance.canFillConventionFeedback() {
            items.insert(Item(name: "פידבק לכנס", imageId: "MenuFeedback", viewControllerId: "ConventionFeedbackViewController"), at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoItemCell", for: indexPath) as! MoreInfoItemCell
        let item = items[indexPath.row]
        cell.imageIcon.image = UIImage(named: item.imageId)?.withRenderingMode(.alwaysTemplate)
        cell.titleLabel.text = item.name
        
        cell.titleLabel.textColor = Colors.textColor
        cell.imageIcon.tintColor = Colors.textColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let feedbackVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: item.viewControllerId))
        navigationController?.pushViewController(feedbackVc, animated: true)
    }
    
    struct Item {
        var name: String
        var imageId: String
        var viewControllerId: String
    }
}
