//
//  UIViewControllerExtentions.swift
//  Conventions
//
//  Created by Bahat David on 28/09/2023.
//  Copyright © 2023 Amai. All rights reserved.
//

import Foundation
import SwiftUI

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Embeds `rootView` as a SwiftUI child, pinned to all four edges of `view`.
    // Pass `backgroundColor: nil` to leave UIHostingController's default background untouched.
    @discardableResult
    func embedSwiftUIView<Content: View>(_ rootView: Content, backgroundColor: UIColor? = .clear) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: rootView)
        if let backgroundColor {
            hostingController.view.backgroundColor = backgroundColor
        }
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
        return hostingController
    }
}
