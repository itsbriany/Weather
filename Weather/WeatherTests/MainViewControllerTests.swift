//
//  MainViewControllerTests.swift
//  WeatherTests
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class MainViewControllerTests: XCTestCase {
    
    var controller: MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.controller = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRSSFeed() {
        // Given we have a RSS feed URL and have loaded the controller's main view
        let url = NSURL(string: "http://weather.gc.ca/rss/city/on-76_e.xml")
        
        // When we pull data, we should get a valid XML file
        XCTAssert(self.controller.getRSSFeed(url!))
        
        // The table view should display at least 7 rows
        XCTAssertGreaterThanOrEqual(self.controller.weatherEntryTableView.accessibilityElementCount(), 7)
        
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
    
    func testSetCurrentDate() {
        // Given we have a date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let dateString = "Halifax " + dateFormatter.stringFromDate(NSDate())
        
        // When the view loads, we should see the date format: <Day Name>, <Month Name> <Day> 
        XCTAssertEqual(self.controller.dateTextView.text, dateString)
    }
}
