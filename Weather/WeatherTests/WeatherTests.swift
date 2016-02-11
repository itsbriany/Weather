//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Brian Yip on 2016-02-10.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    var controller: MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.controller = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetRSSFeed() {
        let url = NSURL(string: "http://weather.gc.ca/rss/city/on-76_e.xml")
        XCTAssert(self.controller.getRSSFeed(url!))
    }
}
