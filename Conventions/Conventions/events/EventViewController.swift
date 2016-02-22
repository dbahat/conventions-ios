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
    @IBOutlet private weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let unwrappedEvent = event else {
            return;
        }
        
        lecturer.text = unwrappedEvent.lecturer;
        eventTitle.text = unwrappedEvent.title;
        hallAndTime.text = unwrappedEvent.hall?.name;
        
        if let eventImage = UIImage(named: "Event_" + unwrappedEvent.id) {
            image.image = eventImage;
        }
        
        guard let descriptionData = unwrappedEvent.description?.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true) else {
            return;
        }
        
        guard let attrStr = try? NSMutableAttributedString(
            data: descriptionData,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ],
            documentAttributes: nil) else {
                return;
        }
        
        attrStr.addAttribute(NSWritingDirectionAttributeName, value: [NSWritingDirection.RightToLeft.rawValue | NSTextWritingDirection.Override.rawValue], range: NSRange(location: 0, length: attrStr.length));
        
        eventDescription.attributedText = attrStr;
        eventDescription.textAlignment = NSTextAlignment.Right;
    }
}
