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

            Item(text: "העסקים הבאים מעניקים הנחה במהלך שלושת ימי הפסטיבל:", title: true),

            Item(text: "<br/>כל כרטיס בתשלום = הנחה בדוכן משחקי ליאם!<br/>1-3 כרטיסים = 10%<br/>4-6 כרטיסים = 25%<br/>7-9 כרטיסים = 30%<br/>10 כרטיסים ומעלה = 50%!<br/>שמרו את הכרטיסים, גשו לדוכן ובחרו משחק בהנחה!<br/>שימו לב: לא ניתן לצבור יותר מ-50% למוצר, ניתן להשתמש בכל כרטיס פעם אחת בלבד",
                 image: UIImage(named: "icon2026_discounts_liam"),
                 linkText: "משחקי ליאם",
                 linkUrl: "https://liamgames.co.il/"),

            Item(text: "<br/>הטבה בחדרי הבריחה אליס בארץ הפלאות: מבעד למראה, ציידי השדים וטיטאניק<br/>בן הילל 7<br/>קבוצה של 4 משתתפים – 100 ₪ הנחה<br/>קבוצה של 5 משתתפים – 125 ₪ הנחה קבוצה של 6 משתתפים ומעלה – 150 ₪ הנחה<br/>אין כפל הנחות ומבצעים.<br/>קוד ההנחה הוא ICON2026<br/>* מימוש ההטבה כפוף לשריון מקום מראש דרך אתר אסקייפרום ובהתאם לזמינות שלנו.<br/>* תוקף ההטבה: 27.09–10.10.",
                 image: UIImage(named: "icon2026_discounts_escape_room"),
                 linkText: "חדר בריחה אליס",
                 linkUrl: "https://www.escaperoom.co.il/tel-aviv-alice"),

            Item(text: "<br/>10% הנחה באתר על כל המועמדים לפרס גפן",
                 image: UIImage(named: "icon2026_discounts_evrit"),
                 linkText: "עברית",
                 linkUrl: "https://www.e-vrit.co.il/?utm_source=google&utm_medium=cpc&utm_content=798376072744_197506920630&utm_term=%D7%A2%D7%91%D7%A8%D7%99%D7%AA&matchtype=e&device=m&network=g&campaignid=23595214959&gad_source=1&gad_campaignid=23595214959&gbraid=0AAAAAC_Jrw7OI1_3TdNYdBNkhELkllIoM&gclid=Cj0KCQjw5bjVBhCiARIsAJzMVnSsMvIflmPT0oRvHUGwDarYuQQ_1cI3fOL4PoH6Hs3nqVACtLwAUIIaApl6EALw_wcB"),

            Item(text: "<br/>30% הנחה על ספרי המדע הבדיוני והפנטזיה באתר<br/>קוד: ATLANTISICON26",
                 image: UIImage(named: "icon2026_discounts_catharsis"),
                 linkText: "קתרזיס",
                 linkUrl: "https://bookscatharsis.com/product-category/%d7%90%d7%98%d7%9c%d7%a0%d7%98%d7%99%d7%a1/"),

            Item(text: "<br/>10% הנחה על המבצעים באתר<br/>קוד: Icon26",
                 image: UIImage(named: "icon2026_discounts_red_heart"),
                 linkText: "לב אדום",
                 linkUrl: "https://red-heart.co.il/product-category/our-books/"),

            Item(text: "<br/>10% הנחה נוספת על המבצעים באתר<br/>המלצה: \"התחנה הבאה\" של בנג'מין רזניק - אורח באייקון",
                 image: UIImage(named: "icon2026_discounts_kibbutz_meuhad"),
                 linkText: "הקיבוץ המאוחד",
                 linkUrl: "http://www.kibutz-poalim.co.il/%D7%A0%D7%95%D7%A2%D7%A8_%D7%95%D7%A4%D7%A0%D7%98%D7%96%D7%99%D7%94"),

            Item(text: "<br/>הנחה של 5% נוספים על המבצע באתר על ספרי מד\"ב ופנטזיה ועל קומיקס ורומן גרפי<br/>קוד: אייקון",
                 image: UIImage(named: "icon2026_discounts_kineret"),
                 linkText: "כנרת זמורה דביר",
                 linkUrl: "https://www.kinbooks.co.il"),

            Item(text: "<br/>משחק תפקידים עלילתי בעולם דמיוני<br/>ערכת משחק ראשונה ב-100 ש\"ח (במקום 150)",
                 image: UIImage(named: "icon2026_discounts_halomykum"),
                 linkText: "חלוםיקום",
                 linkUrl: "https://www.halomykum.co.il/"),

            Item(text: "<br/>האין-ושות<br/>השקת רומן המד\"ב החדש של עוז גורן<br/>להורדה בחינם בזמן הפסטיבל",
                 image: UIImage(named: "icon2026_discounts_oz_goren"),
                 linkText: "עוז גורן",
                 linkUrl: "https://ozgoren.co.il/"),

            Item(text: "<br/>מדבקה לבחירתך במתנה על כל קניה בדוכן",
                 image: UIImage(named: "icon2026_discounts_picturedisc"),
                 linkText: "Picture Disc",
                 linkUrl: "https://www.picturedisc.co.il/"),

            Item(text: "המסעדות הבאות מעניקות הנחה בהצגת כרטיס או תג של הפסטיבל, במהלך שלושת ימי הפסטיבל:", title: true),

            Item(text: "<br/>אובן קובן<br/>הארבעה 16<br/>תה קר או בירה מהחבית ב-10 ש\"ח בהצגת תג, כרטיס או קוספליי<br/>10% הנחה מ11:30-18:00<br/>30% הנחה על האלכוהול 18:00-19:00",
                 image: UIImage(named: "icon2026_discounts_oban_koban"),
                 linkText: "אובן קובן",
                 linkUrl: "https://www.obankoban.co.il/"),

            Item(text: "<br/>קרליבך 20<br/>10% הנחה בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_memphis"),
                 linkText: "ממפיס",
                 linkUrl: "https://www.memphis.co.il/branch/%D7%AA%D7%9C-%D7%90%D7%91%D7%99%D7%91/"),

            Item(text: "<br/>החשמונאים 91<br/>כדור ב-17 (במקום 19)<br/>2 כדורים ב-24 (במקום 26)",
                 image: UIImage(named: "icon2026_discounts_buza"),
                 linkText: "בוזה",
                 linkUrl: "https://buzaicecream.co.il/"),

            Item(text: "<br/>החשמונאים 103<br/>תוספת באבלס חינם בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_tlab"),
                 linkText: "T-LAB",
                 linkUrl: "https://wissotzky-tlab.co.il/"),

            Item(text: "<br/>החשמונאים 103<br/>קפה קר / אייס קפה ב-10 ש\"ח בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_lehamim"),
                 linkText: "מאפיית לחמים",
                 linkUrl: "https://www.lehamim.co.il/"),

            Item(text: "העסקים הבאים העניקו חסות לפסטיבל אייקון:", title: true),

            Item(text: "<br/>כל כרטיס בתשלום = הנחה בדוכן משחקי ליאם!<br/>1-3 כרטיסים = 10%<br/>4-6 כרטיסים = 25%<br/>7-9 כרטיסים = 30%<br/>10 כרטיסים ומעלה = 50%!<br/>שמרו את הכרטיסים, גשו לדוכן ובחרו משחק בהנחה!<br/>שימו לב: לא ניתן לצבור יותר מ-50% למוצר, ניתן להשתמש בכל כרטיס פעם אחת בלבד",
                 image: UIImage(named: "icon2026_discounts_liam"),
                 linkText: "משחקי ליאם",
                 linkUrl: "https://liamgames.co.il/"),

            Item(text: "<br/>הבוטיק בדיזנגוף סנטר הופך למתחם מנוחה וכיף!<br/>קומה 1- במעבר ליד הסופר פארם<br/>כל ימי הפסטיבל בין השעות 13:00-19:00<br/>מתחם מנוחה על ספות כורסאות ופופים<br/>סרט קולנוע בשעה 16:00 בכל יום<br/>29.9 הסיפור שאינו נגמר<br/>30.9 פרסי ג'קסון<br/>1.10 הוקוס פוקוס<br/>פופקורן חינם ועוד הפתעות!<br/>בנוסף יוקרנו בכל יום פרקים מהסדרה בוב ספוג<br/>בואו לנוח במזגן ולחזור לפסטיבל בכוחות מחודשים!",
                 image: UIImage(named: "icon2026_sponsors_center")),

            Item(text: "<br/>המרכז הישראלי לאנימציה - לימודי אנימציה וגיימינג",
                 image: UIImage(named: "icon2026_sponsors_iac"),
                 linkText: "IAC",
                 linkUrl: "https://www.ani-mator.com/open-day/?gad_source=1&gad_campaignid=23597250648"),

            Item(text: "<br/>חברה היוצרת הרפתקאות ומשחקי תפקידים ומפעילה קייטנות דמיון למעלה מעשור",
                 image: UIImage(named: "icon2026_sponsors_keren_hashefa"),
                 linkText: "קרן השפע",
                 linkUrl: "https://xn----8hc5aojohl.co.il/"),

            Item(text: "<br/>הצד האפל של אנטרקטיקה",
                 image: UIImage(named: "icon2026_sponsors_eyal"),
                 linkText: "איל ורמן",
                 linkUrl: "https://e-vrit.co.il/product/36145/%D7%94%D7%A6%D7%93-%D7%94%D7%90%D7%A4%D7%9C-%D7%A9%D7%9C-%D7%90%D7%A0%D7%98%D7%A8%D7%A7%D7%98%D7%99%D7%A7%D7%94"),

            Item(text: "<br/>עימוד מקצועי בכמה לחיצות.",
                 image: UIImage(named: "icon2026_sponsors_pagewise"),
                 linkText: "PageWise",
                 linkUrl: "https://www.page-wise.com/he"),

            Item(text: "<br/>חנות המשחקים הגדולה של ירושלים<br/>הדגמות משחקים לאורך כל הפסטיבל<br/>מתחם משחקי הלוח בסינמטק",
                 image: UIImage(named: "icon2026_sponsors_sirolynia"),
                 linkText: "סירולניה",
                 linkUrl: "https://sirolynia.com/il"),

            Item(text: "<br/>דוכן של אמניות מקומיות ומשלב פופ ארט מהעולם הגיקי ואומנות גותית מעולמות הכישוף.",
                 image: UIImage(named: "icon2026_sponsors_chaotic_neutral"),
                 linkText: "Chaotic Neutral",
                 linkUrl: "https://www.instagram.com/chaoticneutral_collab?stkn=MmhnZ3BwOWJ2YTZ4"),

            Item(text: "<br/>מאיירת ומקעקעת, מעצבת קלפי הדמויות של רוחות הערים",
                 image: UIImage(named: "icon2026_sponsors_tali_reznik"),
                 linkText: "טלי רזניק",
                 linkUrl: "https://www.instagram.com/cattoo_ink/"),

            Item(text: "",
                 image: UIImage(named: "icon2026_sponsors_alma"),
                 linkText: "הוצאת ספרים בעלמא",
                 linkUrl: "https://almabooks.co.il/?srsltid=AfmBOopk1fGQJQcAOS2LxeO7drMyyp8A9iD7HRWxXMcxgpHudOez0Tfw"),

            Item(text: "<br/>חברה המתמחה בגיימיפיקציה: דרך להעביר ידע, ערכים, ומיומנויות באמצעות משחק",
                 image: UIImage(named: "icon2026_sponsors_cerebro"),
                 linkText: "Cerbero",
                 linkUrl: "https://cerebro.co.il/"),

            Item(text: "<br/>להרפתקה בה כל חידה, כל רמז וכל אתגר יתאימו לתוכן, לערכים ולמסרים שלכם.",
                 image: UIImage(named: "icon2026_sponsors_youdo"),
                 linkText: "YouDo",
                 linkUrl: "https://youdoadventures.com/"),

            Item(text: "<br/>הפכו את המרחב הפיזי שלכם לנכס שיווקי, חוויתי, ולימודי",
                 image: UIImage(named: "icon2026_sponsors_marble"),
                 linkText: "Marble",
                 linkUrl: "https://www.playmarble.com/"),

            Item(text: "<br/>תוכנה לניהול כתיבה<br/>20% הנחה קוד: olamot2026",
                 image: UIImage(named: "icon2026_sponsors_bibliocave"),
                 linkText: "BiblioCave",
                 linkUrl: "https://www.bibliocave.com/downloads"),

            Item(text: "<br/>. סלון וחנות ספרים בקומה הראשונה של בית רומנו<br/>מקום לשהות ולשוחח, לצלול עמוק ולגלות אוצרות.",
                 image: UIImage(named: "icon2026_sponsors_matmon"),
                 linkText: "מטמון",
                 linkUrl: "https://matmon.space/"),
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
