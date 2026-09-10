//
//  StandsFilterViewController.swift
//  Conventions
//

import SwiftUI

class StandsFilterViewController: BaseViewController {

    var stands: [Stand] = []
    var filterState: StandAreasSearchState!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "סינון חיפוש"
        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        let rootView = StandsFilterView(stands: stands, filterState: filterState)

        let hostingController = UIHostingController(rootView: rootView)
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
