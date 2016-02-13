//
//  EventViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var event: ConventionEvent?;
    
    @IBOutlet private weak var lecturer: UILabel!
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var hallAndTime: UILabel!
    @IBOutlet private weak var eventDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lecturer.text = event?.lecturer;
        eventTitle.text = event?.title;
        hallAndTime.text = event?.hall?.name;
        
        let attrStr = try! NSMutableAttributedString(
            data: (event?.description!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true))!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ],
            documentAttributes: nil);
        
        attrStr.addAttribute(NSWritingDirectionAttributeName, value: [NSWritingDirection.RightToLeft.rawValue | NSTextWritingDirection.Override.rawValue], range: NSRange(location: 0, length: attrStr.length));
        
        eventDescription.attributedText = attrStr;
        eventDescription.textAlignment = NSTextAlignment.Right;
    }
}
