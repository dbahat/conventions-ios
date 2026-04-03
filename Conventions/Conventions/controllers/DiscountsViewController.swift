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
        super.viewDidLoad()
        
        items = [
            
            Item(text: "\n10% הנחה על כל ספרי פנטזיה ומד\"ב\nקוד: OLAMOT26",
                 image: UIImage(named: "olamot2026_discounts_evrit"),
                 linkText: "עיברית",
                 linkUrl: "https://www.e-vrit.co.il/Category/11/%D7%9E%D7%93_%D7%91_%D7%95%D7%A4%D7%A0%D7%98%D7%96%D7%99%D7%94"),
            
            Item(text: "\n10% הנחה + כפל מבצעים על כל ספרי הפנטזיה והמד\"ב באתר\nקוד: עולמות26",
                 image: UIImage(named: "olamot2026_discounts_matar"),
                 linkText: "מטר",
                 linkUrl: "https://www.matarbooks.co.il/?gad_source=1&amp;gad_campaignid=11243389634"),
            
            Item(text: "\n30% הנחה על כל הספרות הספקולטיבית באתר\nקוד: עולמות2026",
                 image: UIImage(named: "olamot2026_discounts_catharsis"),
                 linkText: "קתרזיס",
                 linkUrl: "https://bookscatharsis.com/product-category/%d7%90%d7%98%d7%9c%d7%a0%d7%98%d7%99%d7%a1/"),
            
            Item(text: "\n10% הנחה על מינוי שנתי\nקוד: עולמות",
                 image: UIImage(named: "olamot2026_discounts_patzkareshet"),
                 linkText: "פצקרשת",
                 linkUrl: "https://patzkareshet.com/"),
            
            Item(text: "\nציוד ואביזרי תפירה\nהנחה באתר עד סוף חודש אפריל\nקוד: olam10",
                 image: UIImage(named: "olamot2026_discounts_bernina"),
                 linkText: "ברנינה",
                 linkUrl: "https://www.bernina.co.il/?utm_source=google&amp;utm_term=&amp;utm_campaign=x&amp;utm_medium=c&amp;utm_content=1007978&amp;gad_source=1&amp;gad_campaignid=21514437813"),
            
            Item(text: "\nפופאפ פוקימון בסנטר\n5% הנחה בחנות + כפל מבצעים\nקוד: OLAM\nגשר הפיל, מול הכל בדולר",
                 image: UIImage(named: "olamot2026_discounts_pokemon"),
                 linkText: "פופאפ פוקימון",
                 linkUrl: "https://www.dizengof-center.co.il/activities/events/?ContentID=71963"),
            
            Item(text: "\nקרפ צרפתי כולל תוספות במקום ב-25 ש\"ח (במקום 31)\nגלידה 3 כדורים ב-25 ש\"ח (במקום 33)\nפרוזן יוגורט ב-25 ש\"ח (במקם 30)\nבניין A קומה שנייה",
                 image: UIImage(named: "olamot2026_discounts_yogo"),
                 linkText: "יוגו – גלידה ויוגורט",
                 linkUrl: "https://www.dizengof-center.co.il/shops/food/?ItemID=62014"),
            
            Item(text: "\n10% הנחה לקהל הכנס\nאמרו \"כנס עולמות\" בתשלום\nבניין A קומה 2",
                 image: UIImage(named: "olamot2026_discounts_tony_vespa"),
                 linkText: "טוני וספה",
                 linkUrl: "https://www.dizengof-center.co.il/shops/food/?ItemID=62005"),
            
            Item(text: "\n10% הנחה בהצגת קופון – ניתן לאסוף בדוכן האגודה בגלריה\nבניין A קומה 1",
                 image: UIImage(named: "olamot2026_discounts_aroma"),
                 linkText: "ארומה",
                 linkUrl: "https://www.aroma.co.il/store/%d7%93%d7%99%d7%96%d7%99%d7%a0%d7%92%d7%95%d7%a3-%d7%a1%d7%a0%d7%98%d7%a8/"),
            
            Item(text: "\nמתחם משחקי לוח בימי הכנס\nמגוון הנחות לקהל הכנס\nבניין B קומת כניסה",
                 image: UIImage(named: "olamot2026_discounts_freak"),
                 linkText: "פריק",
                 linkUrl: "https://apps.sf-f.org.il/kmolamot/"),
            
            Item(text: "\n15% הנחה בחנות OLAMOT15\nסימניה חינם בקניה מעל 150 ש\"ח",
                 image: UIImage(named: "olamot2026_discounts_scaryfairygifts"),
                 linkText: "ScaryFairyGifts",
                 linkUrl: "https://www.scaryfairygifts.com/"),
            
            Item(text: "\nתוכנה לניהול כתיבה\n20% הנחה קוד: olamot2026",
                 image: UIImage(named: "olamot2026_discounts_bibliocave"),
                 linkText: "BiblioCave",
                 linkUrl: "https://www.bibliocave.com/downloads"),
        ]
    }
}

class ActivitiesViewController : DiscountsAndActivitiesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            Item(text: "מקום הגיימינג החדש של תל אביב מגיע לאייקון!<br/>עמדת קונסולות VR עמדת קונסולות בסינמטק:<br/>פלייסטיישן 5, נינטנדו סוויץ\' 2, משקפי מציאות מדומה (VR), בואו לשחק ולהנות עם Silksong, Mario Kart ,Guitar Hero, DJ Hero ועוד.<br/>לאורך כל שעות הפסטיבל, גם ביום שישי!<br/><br/>אחרי אייקון תוכלו למצוא ב-GLHF יותר מ-100 משחקי לוח, יותר מ-200 משחקי וידאו VR, קונסולות רטרו וסימולטור מרוצים, צפייה משותפת באנימה ומשחקי שחמט בתוספת שתייה וחטיפים.<br/>בואו לבקר ברחוב אילת 4 בתל אביב.",
                 image: UIImage(named: "icon2025_activities_glhf"),
                 linkText:"GLHF TLV",
                 linkUrl:"https://www.instagram.com/glhftlvheb/#"),
            
            Item(text:"אייקוד: פעילות בריחה אינטראקטיבית<br/>פעילות בריחה אינטראקטיבית עם צפנים מיוחדים וכספות וירטואליות, ברחבי מתחם הפסטיבל, והכול סביב מדע בדיוני ופנטזיה! הפעילות מתאימה לכל המשפחה ויכולה להתקיים בכל זמן שנוח לכם במהלך אייקון 2025.<br/>איך משתתפים? לוקחים דוכני עמותות בדוכן האגודה<br/> את מפת הרמזים המודפסת, ויוצאים להרפתקה!<br/>האירוע בשיתוף \"אפשר לחשוב\", פעילויות בריחה בהתאמה אישית.<br/>ההשתתפות חופשית בכל שעות הפעילות של דוכן האגודה הישראלית למדע בדיוני ולפנטזיה.",
                 image: UIImage(named: "icon2025_activities_icode"),
                 linkText: "אייקוד",
                 linkUrl: "https://tickets.sf-f.org.il/icon2025/event/%d7%90%d7%99%d7%99%d7%a7%d7%95%d7%93-%d7%a4%d7%a2%d7%99%d7%9c%d7%95%d7%aa-%d7%91%d7%a8%d7%99%d7%97%d7%94-%d7%90%d7%99%d7%a0%d7%98%d7%a8%d7%90%d7%a7%d7%98%d7%99%d7%91%d7%99%d7%aa/"),
            
            Item(text: "ספינת החלל פיניקס: מירוץ החלל הגדול<br/>בואו להטיס חללית ולהשאיר אבק כוכבים ליריבים! תמרנו בין אסטרואידים בהדמיה של מסלול מירוץ חללי ואולי תזכו בתהילה ובפרסים. האם תצליחו להיות הטייסים המהירים ביותר בגלקסיה? אין צורך ברישיון טיסה, אך רצוי ניסיון בג\'ויסטיק.<br/>מתחם ספינת החלל פיניקס מזמין אתכם לתחרות נושאת פרסים. עם קצת מזל והרבה כישרון אולי תהיו בין חמשת האלופים שיעלו לשלב הגמר, ביום חמישי בשעה 18:00.<br/>המתחם ממוקם החללית בחצר הימנית של האשכול, ההשתתפות על בסיס מקום פנוי.",
                 image: UIImage(named: "icon2025_discounts_spaceship"),
                 linkText: "ספינת החלל ״פיניקס״",
                 linkUrl: "https://tickets.sf-f.org.il/icon2025/event/%d7%a1%d7%a4%d7%99%d7%a0%d7%aa-%d7%94%d7%97%d7%9c%d7%9c-%d7%a4%d7%99%d7%a0%d7%99%d7%a7%d7%a1-%d7%9e%d7%99%d7%a8%d7%95%d7%a5-%d7%94%d7%97%d7%9c%d7%9c-%d7%94%d7%92%d7%93%d7%95%d7%9c-1/"),
            
            Item(text: "לגיון 501 הישראלי ולגיון המורדים באייקון “משאלות” – משימה מיוחדת!<br/>אנחנו אמנם באים מגלקסיה רחוקה, אבל הלב שלנו כאן – עם ילדי ישראל.<br/><br/><b>ביום רביעי (8.10.2025) נאסוף צעצועים, בובות ומשחקים חדשים בלבד – באריזתם המקורית והסגורה – למען מחלקות ילדים בבתי חולים ברחבי הארץ.</b><br/><br/>אנא זכרו – נוכל לקבל רק פריטים חדשים, כדי שכל ילד יקבל מתנה קסומה משלו.<br/>בואו להיות הגיבורים האמיתיים של הסיפור הזה – ולהפוך יום רגיל לחיוך ענק ותקווה גדולה.<br/>חפשו את דוכני הדוכן שלנו במתחם הפסטיבל.",
                 image:UIImage(named: "olamot2024_activities_legion501"),
                 linkText: "לגיון 501",
                 linkUrl: "https://www.facebook.com/israel501st/?locale=he_IL"),
            
            Item(text: "ברוכים הבאים למתחם משחקי האינדי הישראלי! <br/> <br/>משחקים חדשים, כולם תוצרת הארץ, שנוצרו בידי מפתחים עצמאיים במגוון סגנונות. <br/>בואו לשחק, ליהנות ולהכיר ראשונים, לפני כל העולם! <br/>בכל אחד מימי הכנס יוצגו מספר מוגבל של משחקים. <br/>המתחם ממוקם מתחם משחקי אינדי בחצר השמאלית של האשכול . השתתפות על בסיס מקום פנוי.",
                 linkText: "מתחם משחקי המחשב",
                 linkUrl: "https://abadi.neocities.org/icon2025/mobile")
        ]
    }
}

class DiscountsAndActivitiesViewController : BaseViewController, UITableViewDataSource {
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet weak var backgroundStackView: UIStackView!
    override func viewDidLoad() {
        topLabel.textColor = Colors.textColor
        backgroundStackView.backgroundColor = Colors.staticHtmlContentColor
    }
    
    var items: [Item] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! DiscountCell
        
        if item.title == nil {
            cell.label.attributedText = item.text.htmlAttributedString()
        } else {
            cell.label.text = item.text
            cell.label.font = UIFont.boldSystemFont(ofSize: 25)
        }

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
