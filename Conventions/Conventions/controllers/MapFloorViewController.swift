//
//  MapFloorViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapFloorViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var floorImageView: UIImageView!

    var floorImage: UIImage?;
    
    override func viewDidLoad() {
        floorImageView.image = floorImage;
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return floorImageView;
    }
    
    
}
