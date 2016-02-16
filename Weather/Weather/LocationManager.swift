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
    
    var allowReveseGeolocationLookup = true
    var location: CLLocation?
    var currentPlacemark: CLPlacemark?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        authenticateGeolocationServices()
    }
    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        handleLocationUpdate(manager, locations: locations, callback: {error -> Void in
            if error != nil {
                print("Error handling location update: " + error!.description)
                return
            }
            print("Current location has updated to: " + self.currentPlacemark!.locality!)
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    }
    
    
    // MARK: Interface
    func handleLocationUpdate(manager: CLLocationManager, locations: [CLLocation], callback: (error: NSError?) -> Void) {
        self.location = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        tryReverseGeolocationLookup(callback)
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func prepareForReverseGeolocationLookup() {
        self.allowReveseGeolocationLookup = true
    }
    
    
    // MARK: Private Interface
    private func authenticateGeolocationServices() {
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func updateCurrentPlacemark(callback: (error: NSError?) -> Void) {
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
    
    private func tryReverseGeolocationLookup(callback: (error: NSError?) -> Void) {
        if self.allowReveseGeolocationLookup {
            self.allowReveseGeolocationLookup = false
            updateCurrentPlacemark(callback)
        }
    }
}