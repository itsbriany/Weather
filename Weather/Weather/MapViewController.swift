//
//  MapViewController.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-13.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UINavigationControllerDelegate {
    
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var currentLocation: CLLocation?
    
    
    // TODO App crashes when geolocation services are off
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(self.currentLocation!)
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    
    // MARK: Interface
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
