//
//  StandDetailsViewController.swift
//  Conventions
//

import SwiftUI

class StandDetailsViewController: BaseViewController {

    var stand: Stand!
    var searchText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView(StandDetailsView(stand: stand, searchText: searchText))
    }
}
