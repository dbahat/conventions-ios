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
            
            Item(text: "<b>משחקי ליאם</b><br>הנחה מצטברת! 5 ש\"ח בדוכן <b>על כל כרטיס בתשלום לאירוע!</b>",
                 image: UIImage(named: "icon2025_discounts_liam"),
                 linkText: "לאתר משחקי ליאם",
                 linkUrl: "https://liamgames.co.il/"),
            
            Item(text: "<b>דיזינגוף סנטר – הגרלה</b><br>באר המשאלות בסנטר! הגרלה נושאת פרסים בשיתוף דיזנגוף סנטר, רכשו כרטיסים דרך התוכניה, הרשמו ותוכלו לזכות ב-<b>2500 ש\"ח!</b>",
                 image: UIImage(named: "icon2025_discounts_dizengoff"),
                 linkText: "לפרטים נוספים",
                 linkUrl: "https://2025.iconfestival.org.il/center/"),
            
            Item(text: "<b>עברית</b><br>10% הנחה על המועמדים לפרס גפן.<br>קוד: <b>MADAB25</b>",
                 image: UIImage(named: "icon2025_discounts_evrit"),
                 linkText: "לפרטים נוספים",
                 linkUrl: "https://www.e-vrit.co.il/Group/8872/%D7%A4%D7%A1%D7%98%D7%99%D7%91%D7%9C_%D7%90%D7%99%D7%99%D7%A7%D7%95%D7%9F_%D7%94%D7%A2%D7%95%D7%9C%D7%99%D7%9D_%D7%9C%D7%92%D7%9E%D7%A8_%D7%A4%D7%A8%D7%A1_%D7%92%D7%A4%D7%9F_25"),

            Item(text: "<b>קתרזיס</b><br>30% הנחה על ספרי מד\"ב באתר.<br>קוד: <b>ICON25</b>",
                 image: UIImage(named: "icon2025_discounts_catharsis"),
                 linkText: "לאתר קתרזיס",
                 linkUrl: "https://bookscatharsis.com/product-category/%d7%90%d7%98%d7%9c%d7%a0%d7%98%d7%99%d7%a1"),
            
            Item(text: "<b>פרדס הוצאה לאור</b><br>10% הנחה על \"טרול\" של מיכל הבורצקי המתארח בפסטיבל, 10% על אאליטה של אלכסיי טולסטוי. מד\"ב קלאסי בתרגום ראשון לעברית. <b>קוד הנחה: אייקון</b>",
                 image: UIImage(named: "icon2025_discounts_pardes"),
                 linkText: "לאתר פרדס",
                 linkUrl: "https://www.pardes.co.il/?id=showbook&amp;catnum=978-965-541-514-8"),
            
            Item(text: "<b>נשיונל ג\'אוגרפיק קידס</b><br>4 חודשים ראשונים ב-25 ש\"ח לחודש בלבד (במקום 49)",
                 image: UIImage(named: "icon2025_discounts_national_geographic_kids"),
                 linkText: "לפרטים נוספים",
                 linkUrl: "https://ngkids.co.il/product/icon"),
                        
            Item(text: "המסעדות הבאות מעניקות הנחה בהצגת כרטיס או תג של הפסטיבל, במהלך שלושת ימי הפסטיבל:", title: true),

            Item(text: "<b>Sorsetto. רחוב הארבעה 16</b><br>15% הנחה על תפריט הצהריים (עד השעה 16:00), מנת חברים מיוחדת בהצגת תג/כרטיס/קוספליי.",
                 image: UIImage(named: "icon2025_discounts_sorsetto"),
                 linkText: "לאתר Sorsetto",
                 linkUrl: "https://www.instagram.com/sorsetto_tlv"),

            Item(text: "<b>בוזה. החשמונאים 91</b><br>כדור אחד ב-17 ש\"ח, 2 כדורים ב-24 ש\"ח לכל באות ובאי הכנס.",
                 image: UIImage(named: "icon2025_discounts_buza"),
                 linkText: "לאתר בוזה",
                 linkUrl: "https://buzaicecream.co.il"),
            
            Item(text: "<b>TLAB. החשמונאים 103.</b><br>תוספת באבלס על חשבון הבית.",
                 image: UIImage(named: "icon2025_discounts_tlab"),
                 linkText: "לאתר T LAB",
                 linkUrl: "https://wissotzky-tlab.co.il/app/uploads/2025/01/%D7%AA%D7%A4%D7%A8%D7%99%D7%98-TLAB-12-24-A4.pdf"),
            
            Item(text: "<b>אובן קובן. הארבעה 16.</b><br>10% הנחה בין השעות 11:00-20:00",
                 image: UIImage(named: "icon2025_discounts_oban_koban"),
                 linkText: "לאתר אובן קובן",
                 linkUrl: "https://www.obankoban.co.il"),
            
            Item(text: "<b>ממפיס. קרליבך 20.</b><br>10% הנחה בהצגת תג/כרטיס/קוספליי",
                 image: UIImage(named: "icon2025_discounts_memphis"),
                 linkText: "לאתר ממפיס",
                 linkUrl: "https://www.memphis.co.il/branch/%D7%AA%D7%9C-%D7%90%D7%91%D7%99%D7%91"),
            
            Item(text: "<b>נייט קוקי. סניף קרליבך בלבד.</b><br><b>2 עוגיות מתנה</b> בהזמנת מארז שישייה.",
                 image: UIImage(named: "icon2025_discounts_night_cookie"),
                 linkText: "לאתר נייט קוקי",
                 linkUrl: "https://www.nightcookie.com"),
            
            Item(text: "<b>ג\'ירף. הארבעה 13.</b><br>20% הנחה על כל הקינוחים",
                 image: UIImage(named: "icon2025_discounts_giraffe"),
                 linkText: "לאתר ההזמנות",
                 linkUrl: "https://tabitisrael.co.il/tabit-order?orgName=Giraffe&amp;step=enter&amp;gad_source=1&amp;gad_campaignid=21132986808"),
            
            Item(text: "<b>ווק טו ווק. החשמונאים 86.</b><br>15% הנחה על כל התפריט, בישיבה או באיסוף עצמי. <b>קוד: CINIMA15</b>",
                 image: UIImage(named: "icon2025_discounts_wok_to_walk"),
                 linkText: "לאתר ההזמנות",
                 linkUrl: "https://tabitisrael.co.il/tabit-order?siteName=woktowalkhahashmonaim&amp;step=enter"),
            
            Item(text: "<b>ארומה TLV. קניון TLV</b><br>5% הנחה בסניף בהצגת תג או כרטיס",
                 image: UIImage(named: "icon2025_discounts_aroma"),
                 linkText: "לאתר ארומה",
                 linkUrl: "https://www.aroma.co.il/store/%D7%A7%D7%A0%D7%99%D7%95%D7%9F-tlv"),
            
            Item(text: "<b>גרג TLV. קניון TLV.</b><br>5% הנחה בהצגת תג/כרטיס/קוספליי",
                 image: UIImage(named: "icon2025_discounts_greg"),
                 linkText: "לאתר גרג",
                 linkUrl: "https://gregcafe.co.il/branch/%D7%92%D7%A8%D7%92-tlv"),
                        
                        
            Item(text: "העסקים הבאים העניקו חסות לפסטיבל אייקון:", title: true),
            
            Item(text: "משחקי ליאם מתרגמת ומנגישה מגוון משחקים נבחרים מהטופ העולמי.<br>המגוון הרחב שלנו מתאים לשחקנים ותיקים, מתחילים ומשפחות.",
                 image: UIImage(named: "icon2025_discounts_liam"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://liamgames.co.il"),
            
            Item(text: "דיזנגוף סנטר",
                 image: UIImage(named: "icon2025_discounts_dizengoff"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://2025.iconfestival.org.il/center"),
            
            Item(text: "פודקאסט הקולנוע של אמיר בוקסבאום",
                 image: UIImage(named: "icon2025_discounts_cinema_podcast"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://open.spotify.com/show/1ZyJFE0v7LnVxwokVIRlJm?si=NHLr_xluRCK0U-PFS3vZ9w"),
            
            Item(text: "פודקאסט הקולנוע והטלוויזיה של מאגי",
                 image: UIImage(named: "icon2025_discounts_magi_podcast"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://open.spotify.com/show/6lDeAFl6OCDjgqemKYL73m?si=708dfd0cfc6b4fea"),
            
            Item(text: "מתחם למשחקי \"צוות חללית\"",
                 image: UIImage(named: "icon2025_discounts_spaceship"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.larp-g.com/spaceshiplarp"),
            
            Item(text: "<b>אייקוד</b><br>פעילות בריחה אינטראקטיבית<br>קחו בדוכן האגודה את מפת הרמזים וצאו להרפתקה!",
                 image: UIImage(named: "icon2025_discounts_icode"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://hovav1.com"),
            
            Item(text: "Out;About<br>Emily\'s Boutoque<br>בסינמטק!",
                 image: UIImage(named: "icon2025_discounts_emily")),
            
            Item(text: "סינמטק תל אביב",
                 image: UIImage(named: "icon2025_discounts_cinematheque"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.cinema.co.il"),
            
            Item(text: "המכללה הישראלית לאנימציה ועיצוב",
                 image: UIImage(named: "icon2025_discounts_iac"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.ani-mator.com"),
            
            Item(text: "חנות התחביב המובילה בארץ למשחקי לוח, משחקי תפקידים ועוד",
                 image: UIImage(named: "icon2025_discounts_kingdom"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://thekingdom.co.il"),
            
            Item(text: "חנות המשחקים הגדולה של ירושלים",
                 image: UIImage(named: "icon2025_discounts_sirolynia"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://sirolynia.com/il"),
            
            Item(text: "ספרים במחירים שמתאימים לכולם",
                 image: UIImage(named: "icon2025_discounts_paper_tiger"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://lp.vp4.me/rbne"),
            
            Item(text: "<b>דוב לדעת</b><br>משחקים עם מילים",
                 image: UIImage(named: "icon2025_discounts_dov"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.dovladaat.com"),
            
            Item(text: "הוצאת עוץ – ספרים עם קסם",
                 image: UIImage(named: "icon2025_discounts_utz"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://utz.co.il"),
            
            Item(text: "ארבע אמניות מקומיות של פופ ארט גיקי ואומנות גותית מעולמות הכישוף",
                 image: UIImage(named: "icon2025_discounts_chaotic"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.instagram.com/chaoticneutral_collab"),
            
            Item(text: "לגיון 501 אוספים תרומות בדוכן",
                 image: UIImage(named: "icon2025_discounts_legion"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://www.501st.com/members/garrisonroster.php?garrisonId=41"),
            
            Item(text: "ארגון נוער גאה, חפשו את הדוכן שלנו בפסטיבל",
                 image: UIImage(named: "icon2025_discounts_igy"),
                 linkText: "לביקור באתר",
                 linkUrl: "https://igy.org.il"),
            
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
