//
//  StandDetailsViewController.swift
//  Conventions
//

import SwiftUI

class StandDetailsViewController: BaseViewController {

    var stand: Stand!

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView(StandDetailsView(stand: stand))
    }
}
