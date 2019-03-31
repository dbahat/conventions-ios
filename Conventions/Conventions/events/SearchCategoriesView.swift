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
    
    @IBOutlet private weak var lecturesSwitch: UISwitch!
    @IBOutlet private weak var workshopsSwitch: UISwitch!
    @IBOutlet private weak var showsSwitch: UISwitch!
    @IBOutlet private weak var othersSwitch: UISwitch!
    @IBOutlet private weak var lecturesLabel: UILabel!
    @IBOutlet private weak var workshopsLabel: UILabel!
    @IBOutlet private weak var showsLabel: UILabel!
    @IBOutlet private weak var othersLabel: UILabel!
    
    weak var delegate: SearchCategoriesProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed(String(describing: SearchCategoriesView.self), owner: self, options: nil)![0] as! UIView;
        view.frame = self.bounds;
        addSubview(view);
        
        lecturesSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        workshopsSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        showsSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        othersSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        lecturesSwitch.onTintColor = Colors.switchButtonsColor
        workshopsSwitch.onTintColor = Colors.switchButtonsColor
        showsSwitch.onTintColor = Colors.switchButtonsColor
        othersSwitch.onTintColor = Colors.switchButtonsColor
        
        lecturesLabel.textColor = Colors.textColor
        workshopsLabel.textColor = Colors.textColor
        showsLabel.textColor = Colors.textColor
        othersLabel.textColor = Colors.textColor
    }
    
    @IBAction fileprivate func lecturesWasTapped(_ sender: UITapGestureRecognizer) {
        lecturesSwitch.setOn(!lecturesSwitch.isOn, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction fileprivate func gamesWasTapped(_ sender: UITapGestureRecognizer) {
        workshopsSwitch.setOn(!workshopsSwitch.isOn, animated: true)
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
        if workshopsSwitch.isOn {
            searchCategories.append(AggregatedSearchCategory.workshops)
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
