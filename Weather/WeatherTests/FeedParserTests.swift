//
//  FeedParserTests.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-11.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class FeedParserTests: XCTestCase {

    var feedParser: FeedParser!
    
    override func setUp() {
        super.setUp()
        let url = NSURL(string: "http://weather.gc.ca/rss/city/on-76_e.xml")
        self.feedParser = FeedParser(url: url!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testParseRSSFeedDefaultConstructor() {
        // Parse the default url provided in setUp
        XCTAssert(self.feedParser.parseFeed())
        
        // Verify that we have content
        XCTAssertGreaterThan(self.feedParser.entriesList.count, 7)
        
        // The entries must hold user friendly data
        for entry in self.feedParser.entriesList {
            XCTAssertNotNil(entry.title)
            XCTAssertNotNil(entry.summary)
            XCTAssertFalse(entry.title!.containsString("\n"))
            XCTAssertFalse(entry.summary!.containsString("\n"))
        }
    }

}
