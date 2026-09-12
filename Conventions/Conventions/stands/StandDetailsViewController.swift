//
//  StandDetailsViewController.swift
//  Conventions
//

import SwiftUI

class StandDetailsViewController: BaseViewController {

    var stand: Stand!

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        let hostingController = UIHostingController(rootView: StandDetailsView(stand: stand))
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
