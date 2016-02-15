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

class LocationManagerTests: XCTestCase {

    var locationManager: LocationManager!
    
    override func setUp() {
        super.setUp()
        self.locationManager = LocationManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGeolocationCoordinates() {
        // Given we have geolocation services on and have a location
        XCTAssertEqual(CLLocationManager.authorizationStatus(), CLAuthorizationStatus.AuthorizedWhenInUse)
        XCTAssertNotNil(self.locationManager.location)
        
        // When an async reverse geolocation lookup is performed
        let readyExpectation = expectationWithDescription("Location manager should have its current placemark set")
        
        
        // We should know the city representing our current location
        self.locationManager.updateCurrentPlacemark({ error -> Void in
            XCTAssertNil(error, "Placemark Error")
            XCTAssertEqual(self.locationManager.currentPlacemark?.locality, "Halifax")
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }

}
