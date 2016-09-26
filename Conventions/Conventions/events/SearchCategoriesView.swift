//
//  SearchCategoriesView.swift
//  Conventions
//
//  Created by David Bahat on 9/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol SearchCategoriesProtocol : class {
    func filterSearchCategoriesChanged(enabledCategories: Array<AggregatedSearchCategory>)
}

class SearchCategoriesView : UIView {
    
    @IBOutlet private weak var lecturesSwitch: UISwitch!
    @IBOutlet private weak var gamesSwitch: UISwitch!
    @IBOutlet private weak var showsSwitch: UISwitch!
    @IBOutlet private weak var othersSwitch: UISwitch!
    
    weak var delegate: SearchCategoriesProtocol?
    
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
    
    @IBAction private func lecturesWasTapped(sender: UITapGestureRecognizer) {
        lecturesSwitch.setOn(!lecturesSwitch.on, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction private func gamesWasTapped(sender: UITapGestureRecognizer) {
        gamesSwitch.setOn(!gamesSwitch.on, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction private func showsWasTapped(sender: UITapGestureRecognizer) {
        showsSwitch.setOn(!showsSwitch.on, animated: true)
        filterSearchCategoriesChanged()
    }
    @IBAction private func othersWasTapped(sender: UITapGestureRecognizer) {
        othersSwitch.setOn(!othersSwitch.on, animated: true)
        filterSearchCategoriesChanged()
    }
    
    private func filterSearchCategoriesChanged() {
        var searchCategories = Array<AggregatedSearchCategory>()
        if lecturesSwitch.on {
            searchCategories.append(AggregatedSearchCategory.Lectures)
        }
        if gamesSwitch.on {
            searchCategories.append(AggregatedSearchCategory.Games)
        }
        if showsSwitch.on {
            searchCategories.append(AggregatedSearchCategory.Shows)
        }
        if othersSwitch.on {
            searchCategories.append(AggregatedSearchCategory.Others)
        }
        
        delegate?.filterSearchCategoriesChanged(searchCategories)
    }
}
