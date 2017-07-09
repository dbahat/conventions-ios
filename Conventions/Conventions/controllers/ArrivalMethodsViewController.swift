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
    
    fileprivate let latitude = 32.0707265;
    fileprivate let longitude = 34.7845003;

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet fileprivate weak var directionsWebView: StaticContentWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
            longitude: longitude, zoom: 16)
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = Convention.displayName
        marker.snippet = Convention.displayName
        marker.map = mapView
        
        guard
            let resourcePath = Bundle.main.resourcePath,
            let directions = try? String(contentsOfFile: resourcePath + "/ArrivalMethodsContent.html")
            else {
                return;
        }
        
        directionsWebView.setContent(directions)
        directionsWebView.delegate = self
        directionsWebView.scrollView.bounces = false
    }

    @IBAction func navigateWithExternalAppWasClicked(_ sender: UIBarButtonItem) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let url = String(format: "waze://?ll=%f,%f&navigate=yes", arguments: [latitude, longitude]);
            UIApplication.shared.openURL(URL(string: url)!);
            return;
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let url = String(format: "comgooglemaps://?center=%f,%f&zoom=16&views=traffic", arguments: [latitude, longitude]);
            UIApplication.shared.openURL(URL(string: url)!);
            return;
        }
        
        let url = String(format: "http://maps.apple.com/?ll=%f,%f", arguments: [latitude, longitude]);
        UIApplication.shared.openURL(URL(string: url)!);
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            
            if (request.url! == URL(string: "http://2016.iconfestival.org.il/info/discounts/")) {
                if let discountsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DiscountsViewController.self)) as? DiscountsViewController {
                    navigationController?.pushViewController(discountsVc, animated: true)
                }
                return false
            }
            
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}
