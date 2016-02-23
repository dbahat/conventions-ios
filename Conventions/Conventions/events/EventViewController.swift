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

        let eventImage = getImage(unwrappedEvent.id);
        
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        image.image = resizeImage(eventImage, newWidth: self.view.frame.width);
        
        // Extract the dominent color from the image and set it as the background
        self.view.backgroundColor = (CCColorCube().extractColorsFromImage(eventImage, flags: 0)[0] as! UIColor);
        
        guard let descriptionData = unwrappedEvent.description?.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true) else {
            return;
        }
        
        guard let attrStr = try? NSMutableAttributedString(
            data: descriptionData,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ],
            documentAttributes: nil) else {
                return;
        }
        
        attrStr.addAttribute(NSWritingDirectionAttributeName, value: [NSWritingDirection.Natural.rawValue | NSTextWritingDirection.Override.rawValue], range: NSRange(location: 0, length: attrStr.length));
        
        eventDescription.attributedText = attrStr;
        eventDescription.textAlignment = NSTextAlignment.Right;
        eventDescription.font = UIFont.systemFontOfSize(14);
    }
    
    func getImage(eventId: String!) -> UIImage! {
        if let eventImage = UIImage(named: "Event_" + eventId) {
            return eventImage;
        }
        
        return UIImage(named: "Event_Default")!
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = image.size.height / image.size.width
        let newHeight = newWidth * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
