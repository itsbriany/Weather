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
    
    func testParseRSSFeedDefaultConstructor() {
        // Parse the default url provided in setUp
        XCTAssert(self.feedParser.parseFeed())
        
        // Verify that we have content
        XCTAssertGreaterThan(self.feedParser.entriesList.count, 7)
        
        // The entries must hold user friendly data
        for entry in self.feedParser.entriesList {
            XCTAssertGreaterThan(entry.title!.characters.count, 1)
            XCTAssertGreaterThan(entry.summary!.characters.count, 1)
        }
    }

}
