//
//  MapFloorViewController.swift
//  Conventions
//
//  Created by David Bahat on 3/7/16.
//  Copyright © 2016 Amai. All rights reserved.
//

class MapFloorViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet fileprivate weak var floorImageView: UIImageView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    var index: Int = 1
    var area: MapArea!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floorImageView.image = area.image;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.title = area.name
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return floorImageView;
    }
    
    @IBAction func mapWasDoubleTapped(_ sender: UITapGestureRecognizer) {
        // In case the current zoom scale is lower then the max, scale it to max on double tap
        let scale = scrollView.zoomScale == scrollView.maximumZoomScale
            ? scrollView.minimumZoomScale
            : scrollView.maximumZoomScale;
        
        scrollView.zoomToPoint(sender.location(in: scrollView), withScale: scale, animated: true);
    }
    
}
