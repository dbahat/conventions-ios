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
            Item(text: "הטבות במסעדות:", title: true),
            Item(text: "המסעדות הבאות מעניקות הנחה בהצגת כרטיס או תג של הפסטיבל, במהלך שני הימים של הכנס:"),
            Item(text: "ארומה. הארבעה 24.\n10% הנחה למעט דילים קיימים בסניף רחוב הארבעה בלבד.",
                 image: UIImage(named: "olamot2024_discounts_aroma"),
                 linkText: "לביקור באתר ארומה",
                 linkUrl: "https://www.aroma.co.il/store/%D7%94%D7%90%D7%A8%D7%91%D7%A2%D7%94-%D7%AA%D7%9C-%D7%90%D7%91%D7%99%D7%91"),
            
            Item(text: "T LAB. החשמונאים 103.\nתוספת באבלס חינם בכל משקה, בהצגת כרטיס כנס.",
                 image: UIImage(named: "olamot2024_discounts_tlab"),
                 linkText: "לביקור באתר T Lab",
                 linkUrl: "https://wissotzky-tlab.co.il"),
            
            Item(text: "בוזה\nהטבה בהצגת כרטיס או תג",
                 image: UIImage(named: "olamot2024_discounts_buzza"),
                 linkText: "לביקור באתר בוזה",
                 linkUrl: "https://www.buzaisrael.co.il"),
            
            Item(text: "הטבות בחנויות:", title: true),
            Item(text: "החנויות הבאות מעניקות הנחה בהצגת כרטיס או תג של הכנס, במהלך שני הימים של הכנס:"),
            Item(text: "הממלכה\nמעטפת Funpack פוקימון בהצגת כרטיס בדוכן.",
                 image: UIImage(named: "olamot2024_discounts_kingdom"),
                 linkText: "לביקור באתר הממלכה",
                 linkUrl: "https://thekingdom.co.il/"),
            
            Item(text: "עברית\n10% הנחה על כל ספרי המד\"ב והפנטזיה\nההנחה בימי הכנס בלבד\nקוד להנחה 10%: OLAMOT10",
                 image: UIImage(named: "olamot2024_discounts_evrit"),
                 linkText: "לביקור באתר עברית",
                 linkUrl: "https://www.e-vrit.co.il/Category/11/%D7%9E%D7%93_%D7%91_%D7%95%D7%A4%D7%A0%D7%98%D7%96%D7%99%D7%94"),

            Item(text: "ספר מתנה בחנות עברית\nספר מתנה! \"רקורסיה\" מאת בלייק קראוץ' להורדה בחינם.\nההטבה בימי הכנס בלבד\nקוד: OLAMOT",
                 image: UIImage(named: "olamot2024_discounts_evrit_recursion"),
                 linkText: "לעמוד הספר רקורסיה",
                 linkUrl: "https://www.e-vrit.co.il/Product/23635/%D7%A8%D7%A7%D7%95%D7%A8%D7%A1%D7%99%D7%94"),

            Item(text: "גיימינג לנד\n5% הנחה בדוכן בהצגת כרטיס",
                 image: UIImage(named: "olamot2024_discounts_gaming_land"),
                 linkText: "לביקור באתר גיימינג לנד",
                 linkUrl: "https://www.gamingland.co.il/"),
            
            Item(text: "חסויות", title: true),
            
            Item(text: "IAC – המכללה הישראלית לאנימציה ועיצוב\nתודה למכללה על החסות מוזמנים.ות לבקר בדוכן",
                 image: UIImage(named: "olamot2024_discounts_iac"),
                 linkText: "לביקור במכללה לאנימציה",
                 linkUrl: "https://www.ani-mator.com/"),
            
            Item(text: "תילתן המכללה לעיצוב ולתקשורת חזותית\nתודה למכללה על החסות מוזמנים.ות לבקר בדוכן",
                 image: UIImage(named: "olamot2024_discounts_tiltan"),
                 linkText: "לביקור במכללת תילתן",
                 linkUrl: "https://www.tiltan.co.il/"),
            
            Item(text: "כנרת זמורה דביר\nתחרות הסיפורים של כנס עולמות בחסות הוצאת כנרת-זמורה-דביר",
                 image: UIImage(named: "olamot2024_discounts_kineret"),
                 linkText: "לביקור באתר של כנרת זמורה דביר",
                 linkUrl: "https://www.kinbooks.co.il"),
            
            Item(text: "מרלין האדומה / דניאלה ג'וליה טראוב",
                 image: UIImage(named: "olamot2024_discounts_marilyn"),
                 linkText: "לרכישת ספר הדיסטופיה הישראלי החדש",
                 linkUrl: "https://bit.ly/RedMarilynUrion"),
        ]
    }
}

class ActivitiesViewController : DiscountsAndActivitiesViewController {
    override func viewDidLoad() {
        items = [
            Item(text: "דיזינגוף סנטר\nקווסט לאיסוף קוביות DND בחסות הסנטר! פרטים בעמדות המודיעין",
                 image: UIImage(named: "olamot2024_activities_dizengoff"),
                 linkText: "לפרטים נוספים על הקווסט",
                 linkUrl: "https://2024.olamot-con.org.il/dizengof-center-adventure/"),
            
            Item(text: "יודו\nחינוך הרפתקני ופיתוח אמצעי הדרכה ולמידה.\nיודו וסרברו מביאים הרפתקה במתחם לאורך כל הכנס, פרטים בעמדות המודיעין",
                 image: UIImage(named: "olamot2024_activities_youdo"),
                 linkText: "לביקור ביודו",
                 linkUrl: "https://youdoadventures.com/"),
            
            Item(text: "סרברו\nסרברו מפתחת חוויות משחקיות מעבירות תוכן וידע לחברות, ארגונים, מוזיאונים, ועוד.\nיודו וסרברו מביאים הרפתקה במתחם לאורך כל הכנס, פרטים בעמדות המודיעין",
                 image: UIImage(named: "olamot2024_activities_cerebro"),
                 linkText: "לביקור בסרברו",
                 linkUrl: "https://cerebro.co.il/"),
            
            Item(text: "משחקי מחשב\nמתחם משחקי מחשב חדשים תוצרת הארץ שיפעל לאורך הכנס כולו",
                 image: UIImage(named: "olamot2024_activities_gaming"),
                 linkText: "לפרטים על מתחם משחקי המחשב לחצו",
                 linkUrl: "https://2024.olamot-con.org.il/services/games-station/"),
            
            Item(text: "ראשות העתיקות",
                 image: UIImage(named: "olamot2024_activities_antiquities"),
                 linkText: "משחקי רצפה ענקיים במתחם הקהילתי",
                 linkUrl: "https://2024.olamot-con.org.il/services/antiquities-activity/"),
            
            Item(text: "Out & About – אמילי רייכר\nהגרלה בדוכן, כל משתתפ.ת זוכה!*\n*ההגרלה באחריות המפעילה בלבד",
                 image: UIImage(named: "olamot2024_activities_emily"),
                 linkText: "לביקור ב-Out & About",
                 linkUrl: "https://www.facebook.com/outandaboutemily/"),
            
            Item(text: "לגיון 501\nלגיון 501 אוספים תרומות ספרים, משחקים, קוספליי ועוד לטובת חלוקה בבתי חולים ומוסדות אחרים",
                 image: UIImage(named: "olamot2024_activities_legion501"),
                 linkText: "לביקור בלגיון 501",
                 linkUrl: "https://www.501.org.il/"),
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
