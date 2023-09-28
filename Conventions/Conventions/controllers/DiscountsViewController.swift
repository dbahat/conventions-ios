//
//  DiscountsViewController.swift
//  Conventions
//
//  Created by Bahat David on 29/09/2022.
//  Copyright © 2022 Amai. All rights reserved.
//

import Foundation

class DiscountsViewController : BaseViewController, UITableViewDataSource {
    @IBOutlet private weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        topLabel.textColor = Colors.textColor
    }
    
    private let items = [
        Item(text: "המסעדות הבאות מעניקות הנחה בהצגת כרטיס או תג של הפסטיבל, במהלך שלושת ימי הפסטיבל:"),
        Item(text: "סודוך. קרליבך 20. כשר בשרי.\nשתייה ב-3 שקלים בקניית מנה.",
             image: UIImage(named: "discounts_suduh")),
        Item(text: "ארומה. הארבעה 24.\n10% הנחה למעט דילים קיימים בסניף רחוב הארבעה בלבד.",
             image: UIImage(named: "discounts_aroma")),
        Item(text: "TLAB. החשמונאים 103.\nתוספת באבלס על חשבון הבית.",
             image: UIImage(named: "discounts_tlab")),
        Item(text: "אובן קובן. הארבעה 16.\n10% הנחה בין השעות 11:30-18:00.",
             image: UIImage(named: "discounts_oban_koban")),
        Item(text: "ממפיס. קרליבך 20. כשר בשר חלק, ירק מהדרין.\n10% הנחה.",
             image: UIImage(named: "discounts_memphis")),
        Item(text: "הטבות:"),
        Item(text: "העסקים הבאים מעניקים הנחה בהצגת כרטיס או תג של הפסטיבל, במהלך שלושת ימי הפסטיבל:"),
        Item(text: "דיזינגוף סנטר. דיזנגוף 50.\nברד חינם בהצגת כרטיס.",
             image: UIImage(named: "discounts_dizengoff_center")),
        Item(text: "עברית ספרים דיגיטלים\nהנחה על כל ספרי ההשקות בפסטיבל ועל המועמדים לפרס גפן.",
             image: UIImage(named: "discounts_evrit")),
        Item(text: "הפונדק\n50% הנחה על כל איי הסערה + סט קוביות מתנה בקניית פאת\'פיינדר בעולמות פראיים.",
             image: UIImage(named: "discounts_pundak")),
        Item(text: "הממלכה\n10 ש\"ח מתנה בהצגת כרטיס/תג.",
             image: UIImage(named: "discounts_kingdom")),
        Item(text: "אסקייפ רום\n10% הנחה למשחק בחדר בריחה ל5 משתתפים ומעלה.\nניתן לממש את ההטבה בימים א׳-ה׳ לחדרי הבריחה \"גיבורי העל\" ו\"פיקסלים\".\nעל מנת לממש את ההטבה יש להזין משחק עם הקוד Icon10 דרך האתר.",
             image: UIImage(named: "discounts_escape_room")),
        Item(text: "עוץ הוצאה לאור\nסימניית אוריגמי מתנה בהצגת תג.",
             image: UIImage(named: "discounts_oz")),
        Item(text: "פעילויות מיוחדות"),
        Item(text: "הארגונים הבאים יקיימו פעילות מיוחדת במהלך פסטיבל אייקון:"),
        Item(text: "רשות העתיקות\n\"משחקי אסטרטגיה בעת העתיקה\" – פעילות משפחות במתחם הקהילתי. הפעילות בחינם.",
             image: UIImage(named: "discounts_antuquities")),
        Item(text: "לגיון 501\nאיסוף תרומות ספרים, משחקים, קוספליי ועוד לטובת חלוקה בבתי חולים ומוסדות אחרים.",
             image: UIImage(named: "discounts_legion501")),
        Item(text: "חסויות"),
        Item(text: "העסקים הבאים העניקו חסות לפסטיבל אייקון:"),
        Item(text: "דיזינגוף סנטר",
             image: UIImage(named: "discounts_dizengoff_center_sponsor")),
        Item(text: "Out&About Emily's Boutique",
             image: UIImage(named: "discounts_emily")),
        Item(text: "קומקיאזה",
             image: UIImage(named: "discounts_comikaza")),
        Item(text: "Lyra Magical Stuff",
             image: UIImage(named: "discounts_lyra")),
        Item(text: "Gaming Land",
             image: UIImage(named: "discounts_gaming_land")),
        Item(text: "הממלכה",
             image: UIImage(named: "discounts_kingdom")),
        Item(text: "נשיונל ג'אוגרפיק קידס",
            image: UIImage(named: "discounts_national_geographic_kids")),
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! DiscountCell
        
        cell.label.text = item.text
        if let image = item.image {
            cell.logoHeightConstraint.constant = image.size.height
            cell.logo.image = image
        } else {
            cell.logoHeightConstraint.isActive = true
            cell.logoHeightConstraint.constant = 0
        }
        
        cell.label.textColor = Colors.textColor
        
        return cell
    }
    
    private struct Item {
        var text: String
        var image: UIImage?
    }
}
