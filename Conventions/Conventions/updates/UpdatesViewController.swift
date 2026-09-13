//
//  UpdatesViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/2/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics

class UpdatesViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        embedSwiftUIContent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        Convention.instance.updates.markAllAsRead()
    }

    private func embedSwiftUIContent() {
        embedSwiftUIView(UpdatesView(onRefresh: { [weak self] in
            await self?.refresh() ?? false
        }))
    }

    private func refresh() async -> Bool {
        // Mark all current updates as old so new events will appear with different UI
        Convention.instance.updates.markAllAsRead()

        let success = await withCheckedContinuation { continuation in
            Convention.instance.updates.refresh { success in
                continuation.resume(returning: success)
            }
        }

        Analytics.logEvent("PullToRefresh", parameters: [
            "name": "RefreshUpdates" as NSObject,
            "success": success as NSObject
        ])

        if !success {
            TTGSnackbar(message: "לא ניתן לעדכן. בדוק חיבור לאינטרנט", duration: TTGSnackbarDuration.middle, superView: self.view).show()
        }

        return success
    }
}
