//
//  ImportedTicketsView.swift
//  Conventions
//
//  Created by Bahat David on 11/09/2021.
//  Copyright © 2021 Amai. All rights reserved.
//

import Foundation

class ImportedTicketsView : UIView {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var updatesButtonImage: UIImageView!
    
    var onLogoutClicked: (() -> Void)?
    var onRefreshClicked: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed(String(describing: ImportedTicketsView.self), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
        
        // Using black & white for maximal contract, to help the convention scanners to read more efficiently
        backgroundColor = Colors.white
        topLabel.textColor = Colors.black
        bottomLabel.textColor = Colors.black
        midLabel.textColor = Colors.black
        
        logoutButton.tintColor = Colors.logoffButtonColor
    }
    
    @IBAction func refreshWasClicked(_ sender: UITapGestureRecognizer) {
        onRefreshClicked?()
    }
    
    @IBAction func logoutWasClicked(_ sender: UIButton) {
        onLogoutClicked?()
    }
    
}
