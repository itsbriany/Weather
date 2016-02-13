//
//  ForecastAITests.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-12.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import Weather

class ForecastAITests: XCTestCase {

    var forecastAI: ForecastAI!
    
    override func setUp() {
        super.setUp()
        self.forecastAI = ForecastAI()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDetermineForcastFromText() {
        // Given we have various weather feeds
        let cloudyText = "LOTS OF CLOUDS WITH VERY LITTLE RAIN"
        let cloudyText2 = "foggy envrionments"
        let cloudyText3 = "Sunday: very cloudy"
        let windyText = "WINDY FROM THE NORTH"
        let rainyText = "A VERY RAINY DAY"
        let tornadoText = "SUPER HIGH WINDS WITH FREQUENT TORNADOES"
        let lightningText = "LIGHTING WITH HIGH VOLTAGE. Little rain"
        let snowyText = "COLD, SNOW, ICE, RAIN"
        let sunshowerText = "IT WAS A VERY SUNNY DAY TODAY WITH VERY LITTLE RAIN"
        let sunnyCloudyText = "SUN COVERED BY CLOUDS. Just your average day..."
        let sunnyText = "Hot day with lots of sun"
        let errorText = "OMGSLFJSLKDJFLJ LSJDFLK SJF LSJDLKDSJLKJF LK <KEYBOARD MASH!!>"
        
        // When we read the text, we should be able to determine the weather conditions
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(cloudyText), WeatherCondition.Cloudy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(cloudyText2), WeatherCondition.Cloudy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(cloudyText3), WeatherCondition.Cloudy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(windyText), WeatherCondition.Windy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(rainyText), WeatherCondition.Rainy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(tornadoText), WeatherCondition.Tornado)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(lightningText), WeatherCondition.Lightning)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(snowyText), WeatherCondition.Snowy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(sunshowerText), WeatherCondition.Sunshower)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(sunnyCloudyText), WeatherCondition.SunnyCloudy)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(sunnyText), WeatherCondition.Sunny)
        XCTAssertEqual(self.forecastAI.getWeatherConditionFromText(errorText), WeatherCondition.Error)
    }
    
    func testExtractMostRecentWeatherEntryTitle() {
        // Given we have a list of weather entry titles
        let feedParser = FeedParser(url: NSURL(string: "http://weather.gc.ca/rss/city/ab-12_e.xml")!)
        XCTAssert(feedParser.parseFeed())
        
        // When we look through them
        let weatherEntriesList = feedParser.entriesList
        
        // We should be able to pick the one that is most relevant to our current time
        // Should contain current conditions
        let mostRecentTitle = self.forecastAI.extractMostRecentWeatherEntryTitle(weatherEntriesList)
        XCTAssertFalse(mostRecentTitle.isEmpty)
        XCTAssert(mostRecentTitle.lowercaseString.containsString(ForecastAI.CurrentWeatherConditionIdentifier))
    }

}
