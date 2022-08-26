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
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var onLogoutClicked: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed(String(describing: ImportedTicketsView.self), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
        
        topLabel.textColor = Colors.textColor
        bottomLabel.textColor = Colors.textColor
        logoutButton.tintColor = Colors.buttonColor
    }
    
    @IBAction func logoutWasClicked(_ sender: UIButton) {
        onLogoutClicked?()
    }
    
}
