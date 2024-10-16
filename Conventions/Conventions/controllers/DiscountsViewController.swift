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
            
            Item(text: "הגרלה בסנטר! כל כרטיס יכול לזכות",
                 image: UIImage(named: "icon2024_discounts_dizengof_lottery"),
                 linkText: "למידע נוסף באתר דיזנגוף סנטר",
                 linkUrl: "https://www.dizengof-center.co.il/activities/events/?ContentID=60925"),
            
            Item(text: "מיצים, גלידות ושייקים ב15% הנחה. קרליבך 20",
                 image: UIImage(named: "icon2024_discounts_vitamin")),
            
            Item(text: "10% הנחה בין השעות 11:30-18:00",
                 image: UIImage(named: "icon2024_discounts_oban_koban"),
                 linkText: "לאתר אובן קובן",
                 linkUrl: "https://www.obankoban.co.il/"),
            
            Item(text: "עוגיה חינם על קניית 3 עוגיות ומעלה",
                 image: UIImage(named: "icon2024_discounts_night_cookie"),
                 linkText: "לאתר עוגיית לילה",
                 linkUrl: "https://www.nightcookie.com/"),
            
            Item(text: "10% הנחה, לא כולל דילים קיימים. סניף הארבעה בלבד",
                 image: UIImage(named: "icon2024_discounts_aroma"),
                 linkText: "לאתר ארומה",
                 linkUrl: "https://www.aroma.co.il/store/%D7%94%D7%90%D7%A8%D7%91%D7%A2%D7%94-%D7%AA%D7%9C-%D7%90%D7%91%D7%99%D7%91/"),
            
            Item(text: "כדור אחד 16 ש\"ח (במקום 18), 2 כדורים 23 ש\"ח (במקום 25)",
                 image: UIImage(named: "icon2024_discounts_buzza"),
                 linkText: "לאתר בוזה",
                 linkUrl: "https://buzaicecream.co.il/"),
            
            Item(text: "טוסט + שתייה + נקניקיית נשנוש ב-45₪ (במקום 55)",
                 image: UIImage(named: "icon2024_discounts_suduch"),
                 linkText: "לאתר סודוך",
                 linkUrl: "https://suduch.co.il/"),

            Item(text: "10% הנחה לא כולל עסקיות צהריים",
                 image: UIImage(named: "icon2024_discounts_memphis"),
                 linkText: "לאתר ממפיס",
                 linkUrl: "https://www.memphis.co.il/about/"),
            
            Item(text: "תוספת באבלס על חשבון הבית",
                 image: UIImage(named: "icon2024_discounts_tlab"),
                 linkText: "לאתר T LAB",
                 linkUrl: "https://wissotzky-tlab.co.il/%d7%94%d7%a1%d7%a0%d7%99%d7%a4%d7%99%d7%9d-%d7%a9%d7%9c%d7%a0%d7%95/"),
            
            Item(text: "שלושה ספרים במתנה בימי הפסטיבל",
                 image: UIImage(named: "icon2024_discounts_steimatzky_free_books"),
                 linkText: "למידע נוסף באתר סטימצקי",
                 linkUrl: "https://d-steimatzky.co.il/?page_id=891070&amp;preview=true"),
            
            Item(text: "25% הנחה לשנה על מינוי לספרים מוקלטים ודיגיטלים בעברית ובאנגלית",
                 image: UIImage(named: "icon2024_discounts_storytel"),
                 linkText: "לאתר storytel",
                 linkUrl: "https://www.storytel.com/il"),
            
            Item(text: "השותפים שלנו", title: true),
            
            Item(text: "דיזנגוף סנטר",
                 image: UIImage(named: "icon2024_discounts_dizengoff"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.dizengof-center.co.il/"),
            
            Item(text: "הוצאה לאור - ספרי צמרת",
                 image: UIImage(named: "icon2024_discounts_tsameret"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://zbooks.co.il/"),
            
            Item(text: "בוטיק Out&About",
                 image: UIImage(named: "icon2024_discounts_emily"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.facebook.com/outandaboutemily?mibextid=ZbWKwL"),
            
            Item(text: "הממלכה - משחקי לוח, משחקי תפקידים ועוד",
                 image: UIImage(named: "icon2024_discounts_kingdom"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://thekingdom.co.il"),
            
            Item(text: "יודו מתמחה בחינוך הרפתקני ופיתוח אמצעי הדרכה ולמידה",
                 image: UIImage(named: "icon2024_discounts_youdo"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://youdoadventures.com/"),
            
            Item(text: "סרברו מפתחת חוויות משחקיות המעבירות תוכן וידע",
                 image: UIImage(named: "icon2024_discounts_cerebro"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://cerebro.co.il/"),
            
            Item(text: "משחקים וספרים לחינוך מדעי ושיווין חברתי",
                 image: UIImage(named: "icon2024_discounts_dov"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://dovladaat.com/shop"),
            
            Item(text: "קרן השפע - יוצרת הרפתקאות ומשחקי דמיון",
                 image: UIImage(named: "icon2024_discounts_keren_hashefa"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://קרן-השפע.co.il/"),
            
            Item(text: "אנימאיה - המרכז לאנימציה ומדיה דיגיטלית",
                 image: UIImage(named: "icon2024_discounts_animaya"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://animaya.co.il/"),
            
            Item(text: "תוכנית \"מפתח\" של התזמורת הפילהרמונית הישראלית",
                 image: UIImage(named: "icon2024_discounts_philharmonicon"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.ipo.co.il"),
            
            Item(text: "החנות - קבוצת תיאטרון",
                 image: UIImage(named: "icon2024_discounts_hanut"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.hanut31.co.il/"),
            
            Item(text: "IAC - המכללה הישראלית לאנימציה ועיצוב",
                 image: UIImage(named: "icon2024_discounts_iac"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.ani-mator.com/"),
            
            Item(text: "בצלאל המחלקה לאומנויות המסך",
                 image: UIImage(named: "icon2024_discounts_bezalel"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.bezalel.ac.il/"),
            
            Item(text: "קהילת למידה של פנטזיה, מדע בדיוני ומשחקי תפקידים בתואר ראשון עם תעודת הוראה",
                 image: UIImage(named: "icon2024_discounts_seminar"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.smkb.ac.il/"),
            
            Item(text: "אופוס הוצאה לאור",
                 image: UIImage(named: "icon2024_discounts_opus"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.opus.co.il/?id=main"),
            
            Item(text: "מודן הוצאה לאור",
                 image: UIImage(named: "icon2024_discounts_modan"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.modan.co.il/"),
            
            Item(text: "פינקוזאורוס - מאי רדומיר",
                 image: UIImage(named: "icon2024_discounts_pinkkosaurus"),
                 linkText: "לביקור באתר",
                 linkUrl: "http://www.pinkkishu.co/shop"),
            
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
