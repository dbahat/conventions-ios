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
        Item(text: "סודוך, רחוב קרליבך 20. כשר בשרי. 27 ש\"ח לטוסט רגיל/נקנקיה בלחמניה ושתייה מהמקרר בתוספת של 3 ש\"ח, עד השעה 16:00.",
             image: UIImage(named: "DiscountSuduh")),
        Item(text: "ארומה, רחוב הארבעה 24. 10% הנחה.",
             image: UIImage(named: "DiscountAroma")),
        Item(text: "\u{200F}TLAB, רחוב החשמונאים 103. גלידה מתנה בקניית משקה.",
             image: UIImage(named: "DiscountTlab")),
        Item(text: "אובן קובן. רחוב הארבעה 16. משקה חינם (סאקה/בירה/שתיה קלה).",
             image: UIImage(named: "DiscountObanKoban")),
        Item(text: "ממפיס, רחוב קרליבך 20. כשר בשר חלק, ירק מהדרין. 10% הנחה.",
             image: UIImage(named: "DiscountMemphis")),
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
