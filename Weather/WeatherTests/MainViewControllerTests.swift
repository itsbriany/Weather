//
//  MainViewControllerTests.swift
//  WeatherTests
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
import MapKit
@testable import Weather

class MainViewControllerTests: XCTestCase, CLLocationManagerDelegate {
    
    var controller: MainViewController!
    var testCurrentDateReadyExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("MainViewNavigationController") as! UINavigationController
        self.controller = navigationController.topViewController as! MainViewController
        
        // Test and load the view at the same time
        XCTAssertNotNil(navigationController.view, "MainViewNavigationController's view is nil")
        XCTAssertNotNil(self.controller.view, "MainViewController's view is nil")
        
        // Let this test class implement CLLocationManagerDelegate
        self.controller.locationManager.locationManager.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatViewHasLoaded() {
        XCTAssertNotNil(self.controller.view)
    }
    
    func testThatWeatherTableViewHasLoaded() {
        XCTAssertNotNil(self.controller.weatherEntryTableView, "The table view must load")
    }
    
    func testGetRSSFeed() {
        // Given we have a RSS feed URL and have loaded the controller's main view
        let url = NSURL(string: "http://weather.gc.ca/rss/city/on-76_e.xml")
        
        // When we pull data, we should get a valid XML file
        XCTAssert(self.controller.getRSSFeed(url!))
        
        // The table view should display at least 7 rows
        XCTAssertGreaterThanOrEqual(self.controller.weatherEntryTableView.numberOfRowsInSection(0), 7)
        
        // The current conditions should not dispay in the table
        for cell in self.controller.weatherEntryTableView.visibleCells {
            if let weatherEntryCell = cell as? WeatherEntryCell {
                let text = weatherEntryCell.titleTextView.text.lowercaseString
                XCTAssertFalse(text.containsString(ForecastAI.CurrentWeatherConditionIdentifier))
            }
        }
        
        // The current weather condition should display
        XCTAssert(self.controller.currrentWeatherEntryTextView.text.lowercaseString.containsString(ForecastAI.CurrentWeatherConditionIdentifier))
    }
    
    func testCurrentDate() {
        // Given we have a date and a view
        self.testCurrentDateReadyExpectation = expectationWithDescription("The date should be set after a reverse CLLocationManager didUpdateLocations delegate fires")
                
        waitForExpectationsWithTimeout(3, handler: { error -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    // TODO: Still need to test segues
    
    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.controller.updateDateTextWhenLocationIsUpdated(manager, didUpdateLocations: locations, callback: { error -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d"
            let dateString = "Halifax " + dateFormatter.stringFromDate(NSDate())
            
            // When the view loads, we should see the date format: <Day Name>, <Month Name> <Day>
            XCTAssertEqual(self.controller.dateTextView.text, dateString)
            self.testCurrentDateReadyExpectation.fulfill()
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        XCTAssertNil(error, "Location Manager failed")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization Status updated")
    }
}