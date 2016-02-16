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
    var didUpdateLocationExpectation: XCTestExpectation!
    
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
        self.didUpdateLocationExpectation = expectationWithDescription("Location manager should have its current placemark set")
        self.locationManager.startUpdatingLocation()
        
        // We should know the city representing our current location
        // (This will be called in the didUpdateLocations delegate)
        
        waitForExpectationsWithTimeout(3, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }

    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.handleLocationUpdate(manager, locations: locations, callback: { error -> Void in
            self.testGeolocationCoordinatesCallback(error)
            self.testThatFeedEntryCanBeExtractedFromCurrentGeolocationCallback(error)
            self.didUpdateLocationExpectation.fulfill()
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    }
    
    
    // MARK: Asynch callbacks
    private func testGeolocationCoordinatesCallback(error: NSError?) {
        XCTAssertNil(error, "Placemark Error")
        XCTAssertNotNil(self.locationManager.location)
        XCTAssertEqual(self.locationManager.currentPlacemark?.locality, "Halifax")
    }
    
    private func testThatFeedEntryCanBeExtractedFromCurrentGeolocationCallback(error: NSError?) {
        let feedEntry = self.locationManager.extractFeedEntryFromGeolocation()
        XCTAssertNil(error, "Placemark error")
        XCTAssertNotNil(feedEntry)
        XCTAssertEqual(feedEntry.url.absoluteString, "http://weather.gc.ca/rss/city/ns-19_e.xml")
        XCTAssertEqual(feedEntry.city, "Halifax")
        XCTAssertEqual(feedEntry.province, "Nova Scotia")
    }
}
