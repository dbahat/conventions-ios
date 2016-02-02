//
//  EventTableViewCell.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var hallName: UILabel!
    @IBOutlet weak var lecturer: UILabel!
    @IBOutlet weak var timeLayout: UIView!
    
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius;
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius);
//        
//        layer.masksToBounds = false;
//        layer.shadowColor = shadowColor?.CGColor;
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity;
//        layer.shadowPath = shadowPath.CGPath;
//    }
}
