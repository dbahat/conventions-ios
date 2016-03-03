//
//  EventViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/6/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var event: ConventionEvent!;
    
    @IBOutlet private weak var lecturer: UILabel!
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var hallAndTime: UILabel!
    @IBOutlet private weak var eventDescription: UITextView!
    @IBOutlet private weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lecturer.text = event.lecturer;
        eventTitle.text = event.title;
        hallAndTime.text = event.hall?.name;
        
        navigationItem.title = event.type?.description;

        let eventImage = getImage(event.id);
        
        // Resize the image so it'll fit the screen width, but keep the same size ratio
        image.image = resizeImage(eventImage, newWidth: self.view.frame.width);
        
        // Extract the dominent color from the image and set it as the background
        self.view.backgroundColor = (CCColorCube().extractColorsFromImage(eventImage, flags: 0)[0] as! UIColor);
        
        guard let descriptionData = event.description?.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true) else {
            return;
        }
        
        guard let attrStr = try? NSMutableAttributedString(
            data: descriptionData,
            options: [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding ],
            documentAttributes: nil) else {
                return;
        }
        
        attrStr.addAttribute(NSWritingDirectionAttributeName,
            value: [NSWritingDirection.Natural.rawValue | NSTextWritingDirection.Override.rawValue],
            range: NSRange(location: 0, length: attrStr.length));
        
        attrStr.convertFontTo(UIFont.systemFontOfSize(14));
        
        eventDescription.attributedText = attrStr;
        eventDescription.textAlignment = NSTextAlignment.Right;
        refreshFavoriteBarIconImage();
    }
    
    override func viewDidAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "EventViewController")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func getImage(eventId: String!) -> UIImage! {
        if let eventImage = UIImage(named: "Event_" + eventId) {
            return eventImage;
        }
        
        return UIImage(named: "Event_Default")!
    }
    
    @IBAction func changeFavoriteStateClicked(sender: UIBarButtonItem) {
        event.attending = !event.attending;
        
        refreshFavoriteBarIconImage();
        
        let message = event.attending == true ? "האירוע התווסף לאירועים שלי" : "האירוע הוסר מהאירועים שלי";
        TTGSnackbar(message: message, duration: TTGSnackbarDuration.Short, superView: view)
            .show();
    }
    
    func refreshFavoriteBarIconImage() {
        navigationItem.rightBarButtonItem?.image = event.attending == true ? UIImage(named: "EventNotAttending") : UIImage(named: "MenuAddToFavorites");
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

extension NSMutableAttributedString
{
    func convertFontTo(font: UIFont)
    {
        var range = NSMakeRange(0, 0)
        
        while (NSMaxRange(range) < length)
        {
            let attributes = attributesAtIndex(NSMaxRange(range), effectiveRange: &range)
            if let oldFont = attributes[NSFontAttributeName]
            {
                let newFont = UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(oldFont.fontDescriptor().symbolicTraits), size: font.pointSize)
                addAttribute(NSFontAttributeName, value: newFont, range: range)
            }
            if let linkAttr = attributes[NSLinkAttributeName]
            {
                print(linkAttr.description);
            }
        }
    }
}
