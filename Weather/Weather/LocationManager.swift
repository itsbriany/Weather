//
//  LocationManager.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-13.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {

    // MARK: Properties
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    var currentPlacemark: CLPlacemark?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        authenticateGeolocationServices()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    }
    
    
    // MARK: Interface
    func updateCurrentPlacemark(callback: (error: NSError?) -> Void) {
        if self.location != nil {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(self.location!, completionHandler: {(placemarks, error)-> Void in
                if error != nil {
                    print("Geolocation failed with error " + error!.description)
                    callback(error: error)
                    return
                }
                if placemarks!.count > 0 {
                    self.currentPlacemark = placemarks![0] as CLPlacemark
                    callback(error: error)
                    return
                }
                print("Something went wrong when requesting geolocation placemarks")
                callback(error: error)
            })
        }
    }
    
    
    // MARK: Private Interface
    private func authenticateGeolocationServices() {
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}