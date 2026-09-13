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
        embedSwiftUIView(rootView)
    }
}
