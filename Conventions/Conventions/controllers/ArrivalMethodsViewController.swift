//
//  ArrivalMethodsViewController.swift
//  Conventions
//
//  Created by David Bahat on 2/29/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import UIKit
import GoogleMaps

class ArrivalMethodsViewController: BaseViewController {
    
    fileprivate let latitude = 32.0707265;
    fileprivate let longitude = 34.7845003;

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet private weak var directionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
            longitude: longitude, zoom: 16)
        mapView.isMyLocationEnabled = false
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
        
        directionsTextView.layer.cornerRadius = 4
        directionsTextView.backgroundColor = Colors.olamot2024_pink50_transparent_80
        directionsTextView.attributedText = directions.htmlAttributedString()
    }

    @IBAction func navigateWithExternalAppWasClicked(_ sender: UIBarButtonItem) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let url = String(format: "waze://?ll=%f,%f&navigate=yes", arguments: [latitude, longitude]);
            UIApplication.shared.open(URL(string: url)!, options: [:]) { (success) in }
            return;
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let url = String(format: "comgooglemaps://?center=%f,%f&zoom=16&views=traffic", arguments: [latitude, longitude]);
            UIApplication.shared.open(URL(string: url)!, options: [:]) { (success) in }
            return;
        }
        
        let url = String(format: "http://maps.apple.com/?ll=%f,%f", arguments: [latitude, longitude]);
        UIApplication.shared.open(URL(string: url)!, options: [:]) { (success) in }
    }
}
