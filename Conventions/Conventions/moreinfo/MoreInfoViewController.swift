//
//  MoreInfoViewController.swift
//  Conventions
//
//  Created by David Bahat on 9/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import SwiftUI

class MoreInfoViewController : BaseViewController {

    var items = [
//        Item(name: "מפת המתחם", imageId: "MenuMap", viewControllerId: "MapViewController"),
//        Item(name: "יד שנייה", imageId: "MenuSecondHand", viewControllerId: "SecondHandViewController"),
        Item(name: "דרכי הגעה", imageId: "MenuArrivalMethods", viewControllerId: "ArrivalMethodsViewController"),
//        Item(name: "הטבות", imageId: "MenuDiscounts", viewControllerId: "DiscountsViewController"),
        Item(name: "דוכנים", imageId: "MenuActivities", makeViewController: { StandAreasViewController() }),
//        Item(name: "פעילויות ומתחמי שת\"פ", imageId: "MenuActivities", viewControllerId: "ActivitesViewController"),
        Item(name: "אודות הכנס", imageId: "MenuAbout", viewControllerId: "AboutViewController"),
        Item(name: "נגישות", imageId: "MenuAccessability", viewControllerId: "AccessabilityViewController"),
        Item(name: "הגדרות", imageId: "MenuSettings", viewControllerId: "NotificationSettingsViewController"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if Convention.instance.canFillConventionFeedback() {
            items.insert(Item(name: "פידבק לכנס", imageId: "MenuFeedback", viewControllerId: "ConventionFeedbackViewController"), at: 0)
        }

        embedSwiftUIContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // This specific page should have no title
        tabBarController?.navigationItem.title = ""
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }

    private func embedSwiftUIContent() {
        let rows = items.map { item in
            MoreInfoRow(name: item.name, imageId: item.imageId) { [weak self] in
                self?.select(item)
            }
        }

        let hostingController = UIHostingController(rootView: MoreInfoView(rows: rows))
        hostingController.view.backgroundColor = .clear

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }

    private func select(_ item: Item) {
        let viewController: UIViewController
        if let makeViewController = item.makeViewController {
            viewController = makeViewController()
        } else if let viewControllerId = item.viewControllerId {
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerId)
        } else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    struct Item {
        var name: String
        var imageId: String
        var viewControllerId: String? = nil
        var makeViewController: (() -> UIViewController)? = nil
    }
}
