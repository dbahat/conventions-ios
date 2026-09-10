//
//  StandsMapViewController.swift
//  Conventions
//

import SwiftUI

// Fullscreen presentation of the stands map. Deliberately self-contained (not a subclass
// of / shared with MapFloorViewController): the stands map and the convention map (Map tab) are
// expected to diverge over time, so they shouldn't be coupled through a shared view controller.
final class StandsMapViewController: UIViewController {

    static var preferredOrientationMask: UIInterfaceOrientationMask {
        guard let size = UIImage(named: "Overview")?.size, size.width > size.height else {
            return .portrait
        }
        return .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        let hostingController = UIHostingController(rootView: StandsMapView())

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
