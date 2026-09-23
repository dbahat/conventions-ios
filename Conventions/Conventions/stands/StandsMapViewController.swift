//
//  StandsMapViewController.swift
//  Conventions
//

import SwiftUI

// Fullscreen presentation of the stands map. Deliberately self-contained (not a subclass
// of / shared with MapFloorViewController): the stands map and the convention map (Map tab) are
// expected to diverge over time, so they shouldn't be coupled through a shared view controller.
final class StandsMapViewController: UIViewController {

    var mapImageName: String = "Overview"

    static func preferredOrientationMask(forMapImageName mapImageName: String) -> UIInterfaceOrientationMask {
        guard let size = UIImage(named: mapImageName)?.size, size.width > size.height else {
            return .portrait
        }
        return .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // No background color: this is a fullscreen opaque map, unlike the other hosted screens.
        embedSwiftUIView(StandsMapView(mapImageName: mapImageName), backgroundColor: nil)
    }
}
