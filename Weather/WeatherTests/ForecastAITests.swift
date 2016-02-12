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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDetermineForcastFromText() {
        // Given we have various weather feeds
        let cloudyText = "LOTS OF CLOUDS WITH VERY LITTLE RAIN"
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

}
