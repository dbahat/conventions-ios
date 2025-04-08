//
//  DiscountsViewController.swift
//  Conventions
//
//  Created by Bahat David on 29/09/2022.
//  Copyright © 2022 Amai. All rights reserved.
//

import Foundation

class DiscountsViewController : DiscountsAndActivitiesViewController {
    
    override func viewDidLoad() {
        items = [
            
            Item(text: "סידרנו לכם הטבות עם טעמים מכוכבים נפלאים!", title: true),
            
            Item(text: "המסעדות הבאות מעניקות הנחה בהצגת כרטיס או תג של הכנס, במהלך שני הימים של הכנס:", title: true),
            
            Item(text: "10% הנחה בין השעות 11:00-18:00",
                 image: UIImage(named: "icon2024_discounts_oban_koban"),
                 linkText: "לאתר אובן קובן",
                 linkUrl: "https://www.obankoban.co.il/"),
            
            Item(text: "10% הנחה בסניף TLV",
                 image: UIImage(named: "olamot2025_discounts_aroma"),
                 linkText: "לאתר ארומה",
                 linkUrl: "https://www.aroma.co.il/store/%D7%A7%D7%A0%D7%99%D7%95%D7%9F-tlv/"),
            
            Item(text: "באבלס על חשבון הבית",
                 image: UIImage(named: "icon2024_discounts_tlab"),
                 linkText: "לאתר T LAB",
                 linkUrl: "https://wissotzky-tlab.co.il/%D7%94%D7%A1%D7%A0%D7%99%D7%A4%D7%99%D7%9D-%D7%A9%D7%9C%D7%A0%D7%95/?gad_source=1"),
            
            Item(text: "הנחה על כל הגלידות בהצגת תג/כרטיס או קוספליי",
                 image: UIImage(named: "icon2024_discounts_buzza"),
                 linkText: "לאתר בוזה",
                 linkUrl: "https://buzaicecream.co.il/"),
            
            Item(text: "10% הנחה בהצגת תג/כרטיס/קוספליי",
                 image: UIImage(named: "icon2024_discounts_memphis"),
                 linkText: "לאתר ממפיס",
                 linkUrl: "https://www.memphis.co.il/"),
            
            Item(text: "השותפים שלנו", title: true),
            
            Item(text: "ספרי צמרת הוצאה לאור",
                 image: UIImage(named: "icon2024_discounts_tsameret"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://zbooks.co.il/"),
            
            Item(text: "הקוביה משחקים",
                 image: UIImage(named: "olamot2025_discounts_hakubia"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.hakubia.com/"),
            
            Item(text: "המכללה הישראלית לאנימציה ועיצוב",
                 image: UIImage(named: "icon2024_discounts_iac"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.ani-mator.com/"),
            
            Item(text: "בוזה",
                 image: UIImage(named: "icon2024_discounts_buzza"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://buzaicecream.co.il/"),
            
            Item(text: "סירולינה",
                 image: UIImage(named: "olamot2025_discounts_sirolynia")),
            
            Item(text: "הממלכה",
                 image: UIImage(named: "icon2024_discounts_kingdom"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://thekingdom.co.il"),
            
            Item(text: "קונצרט מיוחד בהיכל התרבות",
                 image: UIImage(named: "icon2024_discounts_philharmonicon"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.ipo.co.il"),
            
        ]
    }
}

class DiscountsAndActivitiesViewController : BaseViewController, UITableViewDataSource {
    @IBOutlet private weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        topLabel.textColor = Colors.textColor
    }
    
    var items: [Item] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! DiscountCell
        
        cell.label.text = item.text
        cell.label.font = item.title != nil && item.title! ? UIFont.boldSystemFont(ofSize: 25) : UIFont.systemFont(ofSize: 15)

        if let image = item.image {
            cell.logoHeightConstraint.constant = image.size.height
            cell.logo.image = image
        } else {
            cell.logoHeightConstraint.constant = 0
        }
        
        if let url = item.linkUrl {
            cell.link.setTitle(item.linkText, for: .normal)
            cell.linkUrl = URL(string: url)!
            cell.linkHeightConstraint.constant = 30
        } else {
            cell.linkHeightConstraint.constant = 0
        }
        
        cell.label.textColor = Colors.textColor
        cell.link.setTitleColor(Colors.linksColor, for: .normal)
        
        return cell
    }
    
    struct Item {
        var text: String
        var image: UIImage?
        var linkText: String?
        var linkUrl: String?
        var title: Bool?
    }
}
