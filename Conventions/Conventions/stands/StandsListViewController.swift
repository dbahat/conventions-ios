//
//  StandsListViewController.swift
//  Conventions
//

import SwiftUI

class StandsListViewController: BaseViewController {

    var area: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = area
        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        let stands = Convention.instance.stands.getAll().filter { $0.area == area }
        let hostingController = UIHostingController(rootView: StandsListView(stands: stands))
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
}
