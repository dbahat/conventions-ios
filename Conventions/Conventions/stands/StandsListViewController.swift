//
//  StandsListViewController.swift
//  Conventions
//

import SwiftUI

class StandsListViewController: BaseViewController {

    var area: StandArea = StandArea(id: "", title: "")
    var standIdToScrollTo: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = area.title
        embedSwiftUIContent()
    }

    private func embedSwiftUIContent() {
        let stands = Convention.instance.stands.getAll().filter { $0.area?.title == area.title }
        let rootView = StandsListView(
            stands: stands,
            scrollToStandId: standIdToScrollTo,
            mapImageName: area.mapImageName,
            onExpandMapTapped: { [weak self] in
                guard let self, let mapImageName = self.area.mapImageName else { return }
                self.presentFullscreenMap(mapImageName: mapImageName)
            },
            onStandTapped: { [weak self] stand in
                self?.presentStandDetails(stand)
            }
        )
        embedSwiftUIView(rootView)
    }

    private func presentFullscreenMap(mapImageName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let mapViewController = StandsMapViewController()
        mapViewController.mapImageName = mapImageName
        mapViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction { [weak self] _ in
                self?.dismissFullscreenMap(appDelegate: appDelegate)
            }
        )

        let navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController.modalPresentationStyle = .fullScreen

        // Let the user freely rotate the map screen instead of forcing a specific orientation.
        appDelegate.orientationLock = .allButUpsideDown
        present(navigationController, animated: true)
    }

    private func dismissFullscreenMap(appDelegate: AppDelegate) {
        appDelegate.orientationLock = .portrait
        setNeedsUpdateOfSupportedInterfaceOrientations()
        dismiss(animated: true)
    }

    private func presentStandDetails(_ stand: Stand) {
        let viewController = StandDetailsViewController()
        viewController.stand = stand
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(viewController, animated: true)
    }
}
