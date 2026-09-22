//
//  RootNavigationController.swift
//  Conventions
//

import UIKit

// Root navigation controller wrapping the whole app (see "Opening Navigation" in Main.storyboard).
// Provides the app-wide status bar style now that UIViewControllerBasedStatusBarAppearance is enabled,
// replacing the old Info.plist-driven (UIApplication-based) status bar style, which is deprecated
// and a no-op starting iOS 26.
class RootNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
