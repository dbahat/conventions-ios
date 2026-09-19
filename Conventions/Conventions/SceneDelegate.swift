//
//  SceneDelegate.swift
//  Conventions
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard scene is UIWindowScene else { return }

        // window and its rootViewController are already set up here from Main.storyboard
        // (via UISceneStoryboardFile in Info.plist), mirroring what UIMainStoryboardFile used
        // to do pre-scenes. AppDelegate.window is no longer auto-populated, so sync it here.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window = self.window

        // Moved from AppDelegate.didFinishLaunchingWithOptions, which ran after the window
        // already existed under the old launch order; under scenes it now runs first.
        self.window?.tintColor = Colors.black
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Moved from AppDelegate.application(_:open:options:) — scene-based apps deliver the
        // OAuth/AppAuth redirect (SF-F.Conventions:// scheme) here instead.
        guard let url = URLContexts.first?.url,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let authorizationFlow = appDelegate.currentAuthorizationFlow,
              authorizationFlow.resumeExternalUserAgentFlow(with: url)
        else {
            return
        }
        appDelegate.currentAuthorizationFlow = nil
    }
}
