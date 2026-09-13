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
        let stands = Convention.instance.stands.getAll().filter { $0.area?.id == area.id }
        let rootView = StandsListView(
            stands: stands,
            scrollToStandId: standIdToScrollTo,
            onExpandMapTapped: { [weak self] in
                self?.presentFullscreenMap()
            },
            onStandTapped: { [weak self] stand in
                self?.presentStandDetails(stand)
            }
        )
        embedSwiftUIView(rootView)
    }

    private func presentFullscreenMap() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let mapViewController = StandsMapViewController()
        mapViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction { [weak self] _ in
                self?.dismissFullscreenMap(appDelegate: appDelegate)
            }
        )

        let navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController.modalPresentationStyle = .fullScreen

        let orientationMask = StandsMapViewController.preferredOrientationMask
        appDelegate.orientationLock = orientationMask
        present(navigationController, animated: true) {
            let orientation: UIInterfaceOrientation = orientationMask == .landscape ? .landscapeRight : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }

    private func dismissFullscreenMap(appDelegate: AppDelegate) {
        appDelegate.orientationLock = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
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
