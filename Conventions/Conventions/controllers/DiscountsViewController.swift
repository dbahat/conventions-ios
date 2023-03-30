//
//  DiscountsViewController.swift
//  Conventions
//
//  Created by Bahat David on 29/09/2022.
//  Copyright © 2022 Amai. All rights reserved.
//

import Foundation

class DiscountsViewController : BaseViewController, UITableViewDataSource {
    
    private let items = [
        Item(text: "ארומה סניף הארבעה – 10% הנחה",
             image: UIImage(named: "DiscountAroma")),
        Item(text: "סודוך סניף קרליבך – סודוך טוסט ב-29 ש\"ח",
             image: UIImage(named: "DiscountSuduh")),
        Item(text: "ויסוצקי Tlab החשמונאים – תוספת באבל פירותי חינם",
             image: UIImage(named: "DiscountTlab")),
        Item(text: "אובן קובן הארבעה 16 – 10% הנחה",
             image: UIImage(named: "DiscountObanKoban"))
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! DiscountCell
        
        cell.label.text = item.text
        cell.logo.image = item.image
        
        cell.label.textColor = Colors.textColor
        
        return cell
    }
    
    private struct Item {
        var text: String
        var image: UIImage?
    }
}
