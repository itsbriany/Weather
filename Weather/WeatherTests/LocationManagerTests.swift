//
//  LocationManagerTests.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-13.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
import MapKit
@testable import Weather

class LocationManagerTests: XCTestCase, CLLocationManagerDelegate {

    var locationManager: LocationManager!
    var testGeoLocationCoordinatesReadyExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        self.locationManager = LocationManager()
        self.locationManager.locationManager.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGeolocationCoordinates() {
        // Given we have geolocation services on and have a location
        XCTAssertEqual(CLLocationManager.authorizationStatus(), CLAuthorizationStatus.AuthorizedWhenInUse)
        
        // When an async reverse geolocation lookup is performed
        self.testGeoLocationCoordinatesReadyExpectation = expectationWithDescription("Location manager should have its current placemark set")
        self.locationManager.startUpdatingLocation()
        
        // We should know the city representing our current location
        // (This will be called in the didUpdateLocations delegate)
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testThatFeedEntryCanBeExtractedFromCurrentGeolocation() {
        // TODO: This likely needs to be tested asynchronously
        let feedEntry = self.locationManager.extractFeedEntryFromGeolocation()
        XCTAssertNotNil(feedEntry)
        XCTAssertEqual(feedEntry.url.absoluteString, "http://weather.gc.ca/rss/city/ns-19_e.xml")
        XCTAssertEqual(feedEntry.city, "Halifax")
        XCTAssertEqual(feedEntry.province, "Nova Scotia")
    }

    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.handleLocationUpdate(manager, locations: locations, callback: { error -> Void in
            XCTAssertNil(error, "Placemark Error")
            XCTAssertNotNil(self.locationManager.location)
            XCTAssertEqual(self.locationManager.currentPlacemark?.locality, "Halifax")
            self.testGeoLocationCoordinatesReadyExpectation.fulfill()
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    }
}
