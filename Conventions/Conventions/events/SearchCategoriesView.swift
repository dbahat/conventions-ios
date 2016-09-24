//
//  SearchCategoriesView.swift
//  Conventions
//
//  Created by David Bahat on 9/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class SearchCategoriesView : UIView {
    
    @IBOutlet private weak var lecturesSwitch: UISwitch!
    @IBOutlet private weak var gamesSwitch: UISwitch!
    @IBOutlet private weak var showsSwitch: UISwitch!
    @IBOutlet private weak var othersSwitch: UISwitch!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = NSBundle.mainBundle().loadNibNamed(String(SearchCategoriesView), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
        
        lecturesSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5)
        gamesSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5)
        showsSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5)
        othersSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5)
    }
    
    @IBAction private func LecturesWasTapped(sender: UISwitch) {
    }
    @IBAction private func gamesWasTapped(sender: UISwitch) {
    }
    @IBAction private func showsWasTapped(sender: UISwitch) {
    }
    @IBAction private func othersWasTapped(sender: UISwitch) {
    }
}
