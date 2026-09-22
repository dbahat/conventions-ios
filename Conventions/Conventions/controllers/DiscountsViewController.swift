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

        embedItems([

            DiscountItem(text: "הטבות:", title: true),

            DiscountItem(text: "<br/><b>כל כרטיס בתשלום = הנחה בדוכן משחקי ליאם!</b><br/>1-3 כרטיסים = 10%<br/>4-6 כרטיסים = 25%<br/>7-9 כרטיסים = 30%<br/>10 כרטיסים ומעלה = 50%!<br/><b>שמרו את הכרטיסים, גשו לדוכן ובחרו משחק בהנחה!</b><br/>שימו לב: לא ניתן לצבור יותר מ-50% למוצר, ניתן להשתמש בכל כרטיס פעם אחת בלבד",
                 image: UIImage(named: "icon2026_discounts_liam"),
                 linkText: "משחקי ליאם",
                 linkUrl: "https://liamgames.co.il/"),

            DiscountItem(text: "<br/><b>הטבה בחדרי הבריחה אליס בארץ הפלאות: מבעד למראה, ציידי השדים וטיטאניק</b><br/>בן הילל 7<br/>קבוצה של 4 משתתפים – 100 ₪ הנחה<br/>קבוצה של 5 משתתפים – 125 ₪ הנחה<br/>קבוצה של 6 משתתפים ומעלה – 150 ₪ הנחה<br/>אין כפל הנחות ומבצעים.<br/>קוד ההנחה הוא <b>ICON2026</b><br/>* מימוש ההטבה כפוף לשריון מקום מראש דרך אתר אסקייפרום ובהתאם לזמינות שלנו.<br/>* תוקף ההטבה: 27.09–10.10.",
                 image: UIImage(named: "icon2026_discounts_escape_room"),
                 linkText: "חדר בריחה אליס",
                 linkUrl: "https://www.escaperoom.co.il/tel-aviv-alice"),

            DiscountItem(text: "<br/>10% הנחה באתר על כל המועמדים לפרס גפן",
                 image: UIImage(named: "icon2026_discounts_evrit"),
                 linkText: "עברית",
                 linkUrl: "https://www.e-vrit.co.il/?utm_source=google&utm_medium=cpc&utm_content=798376072744_197506920630&utm_term=%D7%A2%D7%91%D7%A8%D7%99%D7%AA&matchtype=e&device=m&network=g&campaignid=23595214959&gad_source=1&gad_campaignid=23595214959&gbraid=0AAAAAC_Jrw7OI1_3TdNYdBNkhELkllIoM&gclid=Cj0KCQjw5bjVBhCiARIsAJzMVnSsMvIflmPT0oRvHUGwDarYuQQ_1cI3fOL4PoH6Hs3nqVACtLwAUIIaApl6EALw_wcB"),

            DiscountItem(text: "<br/>30% הנחה על ספרי המדע הבדיוני והפנטזיה באתר<br/>קוד: <b>ATLANTISICON26</b>",
                 image: UIImage(named: "icon2026_discounts_catharsis"),
                 linkText: "קתרזיס",
                 linkUrl: "https://bookscatharsis.com/product-category/%d7%90%d7%98%d7%9c%d7%a0%d7%98%d7%99%d7%a1/"),

            DiscountItem(text: "<br/>10% הנחה על המבצעים באתר<br/>קוד: <b>Icon26</b>",
                 image: UIImage(named: "icon2026_discounts_red_heart"),
                 linkText: "לב אדום",
                 linkUrl: "https://red-heart.co.il/product-category/our-books/"),

            DiscountItem(text: "<br/>10% הנחה נוספת על המבצעים באתר<br/>המלצה: \"התחנה הבאה\" של בנג'מין רזניק - אורח באייקון",
                 image: UIImage(named: "icon2026_discounts_kibbutz_meuhad"),
                 linkText: "הקיבוץ המאוחד",
                 linkUrl: "http://www.kibutz-poalim.co.il/%D7%A0%D7%95%D7%A2%D7%A8_%D7%95%D7%A4%D7%A0%D7%98%D7%96%D7%99%D7%94"),

            DiscountItem(text: "<br/>הנחה של 5% נוספים על המבצע באתר על ספרי מד\"ב ופנטזיה ועל קומיקס ורומן גרפי<br/>קוד: <b>אייקון</b>",
                 image: UIImage(named: "icon2026_discounts_kineret"),
                 linkText: "כנרת זמורה דביר",
                 linkUrl: "https://www.kinbooks.co.il"),

            DiscountItem(text: "<br/>משחק תפקידים עלילתי בעולם דמיוני<br/>ערכת משחק ראשונה ב-100 ש\"ח (במקום 150)",
                 image: UIImage(named: "icon2026_discounts_halomykum"),
                 linkText: "חלוםיקום",
                 linkUrl: "https://www.halomykum.co.il/"),

            DiscountItem(text: "<br/><b>האין-ושות</b><br/>השקת רומן המד\"ב החדש של עוז גורן<br/>להורדה בחינם בזמן הפסטיבל",
                 image: UIImage(named: "icon2026_discounts_oz_goren"),
                 linkText: "עוז גורן",
                 linkUrl: "https://ozgoren.co.il/"),

            DiscountItem(text: "<br/>מדבקה לבחירתך במתנה על כל קניה בדוכן",
                 image: UIImage(named: "icon2026_discounts_picturedisc"),
                 linkText: "Picture Disc",
                 linkUrl: "https://www.picturedisc.co.il/"),

            DiscountItem(text: "הנחות במסעדות:", title: true),

            DiscountItem(text: "<br/>אובן קובן<br/>הארבעה 16<br/>תה קר או בירה מהחבית ב-10 ש\"ח בהצגת תג, כרטיס או קוספליי<br/>10% הנחה מ11:30-18:00<br/>30% הנחה על האלכוהול 18:00-19:00",
                 image: UIImage(named: "icon2026_discounts_oban_koban"),
                 linkText: "אובן קובן",
                 linkUrl: "https://www.obankoban.co.il/"),

            DiscountItem(text: "<br/>קרליבך 20<br/>10% הנחה בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_memphis"),
                 linkText: "ממפיס",
                 linkUrl: "https://www.memphis.co.il/branch/%D7%AA%D7%9C-%D7%90%D7%91%D7%99%D7%91/"),

            DiscountItem(text: "<br/>החשמונאים 91<br/>כדור ב-17 (במקום 19)<br/>2 כדורים ב-24 (במקום 26)",
                 image: UIImage(named: "icon2026_discounts_buza"),
                 linkText: "בוזה",
                 linkUrl: "https://buzaicecream.co.il/"),

            DiscountItem(text: "<br/>החשמונאים 103<br/>תוספת באבלס חינם בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_tlab"),
                 linkText: "T-LAB",
                 linkUrl: "https://wissotzky-tlab.co.il/"),

            DiscountItem(text: "<br/>החשמונאים 103<br/>קפה קר / אייס קפה ב-10 ש\"ח בהצגת תג, כרטיס או קוספליי",
                 image: UIImage(named: "icon2026_discounts_lehamim"),
                 linkText: "מאפיית לחמים",
                 linkUrl: "https://www.lehamim.co.il/"),

            DiscountItem(text: "השותפים שלנו:", title: true),

            DiscountItem(text: "<br/>כל כרטיס בתשלום = הנחה בדוכן משחקי ליאם!<br/>1-3 כרטיסים = 10%<br/>4-6 כרטיסים = 25%<br/>7-9 כרטיסים = 30%<br/>10 כרטיסים ומעלה = 50%!<br/>שמרו את הכרטיסים, גשו לדוכן ובחרו משחק בהנחה!<br/>שימו לב: לא ניתן לצבור יותר מ-50% למוצר, ניתן להשתמש בכל כרטיס פעם אחת בלבד",
                 image: UIImage(named: "icon2026_discounts_liam"),
                 linkText: "משחקי ליאם",
                 linkUrl: "https://liamgames.co.il/"),

            DiscountItem(text: "<br/><b>הבוטיק בדיזנגוף סנטר הופך למתחם מנוחה וכיף!</b><br/>קומה 1- במעבר ליד הסופר פארם<br/>כל ימי הפסטיבל בין השעות 13:00-19:00<br/>מתחם מנוחה על ספות כורסאות ופופים<br/>סרט קולנוע בשעה 16:00 בכל יום<br/>29.9 הסיפור שאינו נגמר<br/>30.9 פרסי ג'קסון<br/>1.10 הוקוס פוקוס<br/>פופקורן חינם ועוד הפתעות!<br/>בנוסף יוקרנו בכל יום פרקים מהסדרה בוב ספוג<br/>בואו לנוח במזגן ולחזור לפסטיבל בכוחות מחודשים!",
                 image: UIImage(named: "icon2026_sponsors_center")),

            DiscountItem(text: "<br/>המרכז הישראלי לאנימציה - לימודי אנימציה וגיימינג",
                 image: UIImage(named: "icon2026_sponsors_iac"),
                 linkText: "IAC",
                 linkUrl: "https://www.ani-mator.com/open-day/?gad_source=1&gad_campaignid=23597250648"),

            DiscountItem(text: "<br/>חברה היוצרת הרפתקאות ומשחקי תפקידים ומפעילה קייטנות דמיון למעלה מעשור",
                 image: UIImage(named: "icon2026_sponsors_keren_hashefa"),
                 linkText: "קרן השפע",
                 linkUrl: "https://xn----8hc5aojohl.co.il/"),

            DiscountItem(text: "<br/><b>הצד האפל של אנטרקטיקה</b>",
                 image: UIImage(named: "icon2026_sponsors_eyal"),
                 linkText: "איל ורמן",
                 linkUrl: "https://e-vrit.co.il/product/36145/%D7%94%D7%A6%D7%93-%D7%94%D7%90%D7%A4%D7%9C-%D7%A9%D7%9C-%D7%90%D7%A0%D7%98%D7%A8%D7%A7%D7%98%D7%99%D7%A7%D7%94"),

            DiscountItem(text: "<br/>עימוד מקצועי בכמה לחיצות.",
                 image: UIImage(named: "icon2026_sponsors_pagewise"),
                 linkText: "PageWise",
                 linkUrl: "https://www.page-wise.com/he"),

            DiscountItem(text: "<br/>חנות המשחקים הגדולה של ירושלים<br/>הדגמות משחקים לאורך כל הפסטיבל<br/>מתחם משחקי הלוח בסינמטק",
                 image: UIImage(named: "icon2026_sponsors_sirolynia"),
                 linkText: "סירולניה",
                 linkUrl: "https://sirolynia.com/il"),

            DiscountItem(text: "<br/>דוכן של אמניות מקומיות ומשלב פופ ארט מהעולם הגיקי ואומנות גותית מעולמות הכישוף.",
                 image: UIImage(named: "icon2026_sponsors_chaotic_neutral"),
                 linkText: "Chaotic Neutral",
                 linkUrl: "https://www.instagram.com/chaoticneutral_collab?stkn=MmhnZ3BwOWJ2YTZ4"),

            DiscountItem(text: "<br/>מאיירת ומקעקעת, מעצבת קלפי הדמויות של רוחות הערים",
                 image: UIImage(named: "icon2026_sponsors_tali_reznik"),
                 linkText: "טלי רזניק",
                 linkUrl: "https://www.instagram.com/cattoo_ink/"),

            DiscountItem(text: "",
                 image: UIImage(named: "icon2026_sponsors_alma"),
                 linkText: "הוצאת ספרים בעלמא",
                 linkUrl: "https://almabooks.co.il/?srsltid=AfmBOopk1fGQJQcAOS2LxeO7drMyyp8A9iD7HRWxXMcxgpHudOez0Tfw"),

            DiscountItem(text: "<br/>חברה המתמחה בגיימיפיקציה: דרך להעביר ידע, ערכים, ומיומנויות באמצעות משחק",
                 image: UIImage(named: "icon2026_sponsors_cerebro"),
                 linkText: "Cerbero",
                 linkUrl: "https://cerebro.co.il/"),

            DiscountItem(text: "<br/>להרפתקה בה כל חידה, כל רמז וכל אתגר יתאימו לתוכן, לערכים ולמסרים שלכם.",
                 image: UIImage(named: "icon2026_sponsors_youdo"),
                 linkText: "YouDo",
                 linkUrl: "https://youdoadventures.com/"),

            DiscountItem(text: "<br/>הפכו את המרחב הפיזי שלכם לנכס שיווקי, חוויתי, ולימודי",
                 image: UIImage(named: "icon2026_sponsors_marble"),
                 linkText: "Marble",
                 linkUrl: "https://www.playmarble.com/"),

            DiscountItem(text: "<br/>תוכנה לניהול כתיבה<br/>20% הנחה קוד: <b>olamot2026</b>",
                 image: UIImage(named: "icon2026_sponsors_bibliocave"),
                 linkText: "BiblioCave",
                 linkUrl: "https://www.bibliocave.com/downloads"),

            DiscountItem(text: "<br/>. סלון וחנות ספרים בקומה הראשונה של בית רומנו<br/>מקום לשהות ולשוחח, לצלול עמוק ולגלות אוצרות.",
                 image: UIImage(named: "icon2026_sponsors_matmon"),
                 linkText: "מטמון",
                 linkUrl: "https://matmon.space/"),
        ])
    }
}

class ActivitiesViewController : DiscountsAndActivitiesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        embedItems([
            DiscountItem(text: "<b>מסלולי תוכן</b><br/>תוכניית הפסטיבל ענקית, מופלאה ועמוסה בכל טוב!<br/>כדי לעזור לך בהתמצאות הכנו מפת שבילים מומלצים לכל יום שיאפשרו לך להנות מכל מה שיש לפסטיבל להציע בנחת ובכיף. אפשר למצוא את ההמלצות בקלות על ידי שימוש בתגית המתאימה <a href=\"https://tickets.sf-f.org.il/icon2026/\">בתוכניה באתר</a>.<br/><br/><b>יום שלישי 29.9.26</b><br/>שביל טעימה מאייקון<br/>שביל מסביב לעולם<br/><br/><b>יום רביעי 30.9.26</b><br/>שביל רומנטזי<br/>השביל הפעיל<br/><br/><b>יום חמישי 1.10.26</b><br/>שביל עומק<br/>שביל ילדים ונוער<br/><br/><b>מסלולי משחקי תפקידים</b><br/>שביל משחקי תפקידים - עיוני<br/>שביל משחקי תפקידים - לילדים<br/>שביל משחקי תפקידים - לנוער<br/>שביל משחקי תפקידים - ערפדים<br/>שביל משחקי תפקידים - אייקון אחרי העבודה"),

            DiscountItem(text: "<b>קלפי רוחות ערים</b><br/><b>אספו את כולם!</b><br/>קלפי הדמויות של הפקת המקור \"רוחות הערים עושות סדר\" מחכים ברחבי הפסטיבל! קבלו את הקלף הראשון בדוכן האגודה ועקבו אחרי ההוראות כדי להשלים את כל האוסף!<br/>פרטים נוספים בדוכן האגודה ובמודיעין",
                 image: UIImage(named: "icon2026_activities_city_spirits_cards")),

            DiscountItem(text: "<b>מרחב בריחה בפסטיבל: סוד הפלאות</b><br/>היכונו להרפתקה! סוד הפלאות, מרחב חידות חוויתי ברחבי הכנס. בכל שעות היום וללא עלות, התחילו כאן או גשו לדוכן המודיעין וסרקו את הקוד על מנת להתחיל במסע<br/>כבר מספר שבועות שאנחנו בא.ל.י.ס. עוקבים אחר \"הארנב הלבן\", כנופיית ההאקרים הידועה לשמצה. הארנב הלבן טוענים שהנהלת אייקון מסתירה מידע על קיומם של חייזרים, יקומים מקבילים, ושלל עולמות פנטסטיים. אנחנו לא יכולים לאשר או להכחיש את הטענות, אך כך או כך אסור לנו לתת לארנב הלבן להפיל את אייקון. אנו זקוקים לצוות הטוב ביותר, האם תתגייסו למשימה?",
                 image: UIImage(named: "icon2026_activities_secret_of_wonders")),

            DiscountItem(text: "<b>הבוטיק בדיזנגוף סנטר הופך למתחם מנוחה וכיף!</b><br/>קומה 1- במעבר ליד הסופר פארם<br/>כל ימי הפסטיבל בין השעות 13:00-19:00<br/>מתחם מנוחה על ספות כורסאות ופופים<br/>סרט קולנוע בשעה 16:00 בכל יום<br/>29.9 הסיפור שאינו נגמר<br/>30.9 פרסי ג'קסון<br/>1.10 הוקוס פוקוס<br/>פופקורן חינם ועוד הפתעות!<br/>בנוסף יוקרנו בכל יום פרקים מהסדרה בוב ספוג<br/>בואו לנוח במזגן ולחזור לפסטיבל בכוחות מחודשים!",
                 image: UIImage(named: "icon2026_sponsors_center")),

            DiscountItem(text: "<b>מתחם משחקי מחשב</b><br/>מתחם משחקי אינדי ישראלים!<br/>כמו בכל שנה בשנים האחרונות מוזמנות ומוזמנים למתחם הגיימינג בו תוכלו לשחק במשחקים ישראלים חדשים, לפגוש את המפתחים ולהשאיר רשמים וביקורות!"),

            DiscountItem(text: "חנות המשחקים הגדולה של ירושלים<br/>הדגמות משחקים לאורך כל הפסטיבל<br/>מתחם משחקי הלוח בסינמטק",
                 image: UIImage(named: "icon2026_sponsors_sirolynia"),
                 linkText: "סירולניה",
                 linkUrl: "https://sirolynia.com/il"),

            DiscountItem(text: "קרן השפע באייקון!<br/>חברת משחקי התפקידים הותיקה מגיעה להרפתקאות מופלאות בפסטיבל<br/>סיפור הרפתקאות<br/>חרבות וכשפים במולאר<br/>מהרו להזמין כרטיסים, המלאי מוגבל!",
                 image: UIImage(named: "icon2026_sponsors_keren_hashefa"),
                 linkText: "קרן השפע",
                 linkUrl: "https://xn----8hc5aojohl.co.il/"),
        ])
    }
}

class DiscountsAndActivitiesViewController : BaseViewController {
    func embedItems(_ items: [DiscountItem]) {
        embedSwiftUIView(DiscountsListView(items: items))
    }
}
