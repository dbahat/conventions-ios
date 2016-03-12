//
//  MapFloorViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapFloorViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var floorImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var floorImage: UIImage?;
    
    override func viewDidLoad() {
        floorImageView.image = floorImage;
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return floorImageView;
    }
    
    @IBAction func mapWasDoubleTapped(sender: UITapGestureRecognizer) {
        // In case the current zoom scale is lower then the max, scale it to max on double tap
        let scale = scrollView.zoomScale == scrollView.maximumZoomScale
            ? scrollView.minimumZoomScale
            : scrollView.maximumZoomScale;
        
        scrollView.zoomToPoint(sender.locationInView(scrollView), withScale: scale, animated: true);
    }
    
}
