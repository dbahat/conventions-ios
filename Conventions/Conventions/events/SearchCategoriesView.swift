//
//  SearchCategoriesView.swift
//  Conventions
//
//  Created by David Bahat on 9/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol SearchCategoriesProtocol : class {
    func filterSearchCategoriesChanged(_ enabledCategories: Array<AggregatedSearchCategory>)
}

class SearchCategoriesView : UIView {
    
    @IBOutlet fileprivate weak var lecturesSwitch: UISwitch!
    @IBOutlet fileprivate weak var gamesSwitch: UISwitch!
    @IBOutlet fileprivate weak var showsSwitch: UISwitch!
    @IBOutlet fileprivate weak var othersSwitch: UISwitch!
    
    weak var delegate: SearchCategoriesProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed(String(describing: SearchCategoriesView.self), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
        
        lecturesSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        gamesSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        showsSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        othersSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    @IBAction fileprivate func lecturesWasTapped(_ sender: UITapGestureRecognizer) {
        lecturesSwitch.setOn(!lecturesSwitch.isOn, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction fileprivate func gamesWasTapped(_ sender: UITapGestureRecognizer) {
        gamesSwitch.setOn(!gamesSwitch.isOn, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction fileprivate func showsWasTapped(_ sender: UITapGestureRecognizer) {
        showsSwitch.setOn(!showsSwitch.isOn, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction fileprivate func othersWasTapped(_ sender: UITapGestureRecognizer) {
        othersSwitch.setOn(!othersSwitch.isOn, animated: true)
        filterSearchCategoriesChanged()
    }
    
    fileprivate func filterSearchCategoriesChanged() {
        var searchCategories = Array<AggregatedSearchCategory>()
        if lecturesSwitch.isOn {
            searchCategories.append(AggregatedSearchCategory.lectures)
        }
        if gamesSwitch.isOn {
            searchCategories.append(AggregatedSearchCategory.games)
        }
        if showsSwitch.isOn {
            searchCategories.append(AggregatedSearchCategory.shows)
        }
        if othersSwitch.isOn {
            searchCategories.append(AggregatedSearchCategory.others)
        }
        
        delegate?.filterSearchCategoriesChanged(searchCategories)
    }
}
