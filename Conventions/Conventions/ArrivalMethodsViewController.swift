//
//  ArrivalMethodsViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import GoogleMaps

class ArrivalMethodsViewController: UIViewController {
    
    let latitude = 31.786372
    let longitude = 35.202425

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude,
            longitude: longitude, zoom: 16)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = "הארוקון 2016"
        marker.snippet = "בנייני האומה"
        marker.map = mapView
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
}
