//
//  ArrivalMethodsViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import GoogleMaps

class ArrivalMethodsViewController: BaseViewController, UIWebViewDelegate {
    
    private let latitude = 32.0707265;
    private let longitude = 34.7845003;

    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var directionsWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude,
            longitude: longitude, zoom: 16)
        mapView.myLocationEnabled = true
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = Convention.displayName
        marker.snippet = Convention.displayName
        marker.map = mapView
        
        guard
            let resourcePath = NSBundle.mainBundle().resourcePath,
            let directions = try? String(contentsOfFile: resourcePath + "/ArrivalMethodsContent.html")
            else {
                return;
        }
        
        directionsWebView.setContent(directions)
        directionsWebView.delegate = self
        directionsWebView.scrollView.bounces = false
    }

    @IBAction func navigateWithExternalAppWasClicked(sender: UIBarButtonItem) {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "waze://")!) {
            let url = String(format: "waze://?ll=%f,%f&navigate=yes", arguments: [latitude, longitude]);
            UIApplication.sharedApplication().openURL(NSURL(string: url)!);
            return;
        }
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
            let url = String(format: "comgooglemaps://?center=%f,%f&zoom=16&views=traffic", arguments: [latitude, longitude]);
            UIApplication.sharedApplication().openURL(NSURL(string: url)!);
            return;
        }
        
        let url = String(format: "http://maps.apple.com/?ll=%f,%f", arguments: [latitude, longitude]);
        UIApplication.sharedApplication().openURL(NSURL(string: url)!);
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            
            if (request.URL!.isEqual(NSURL(string: "http://2016.iconfestival.org.il/info/discounts/"))) {
                if let discountsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(DiscountsViewController)) as? DiscountsViewController {
                    navigationController?.pushViewController(discountsVc, animated: true)
                }
                return false
            }
            
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
