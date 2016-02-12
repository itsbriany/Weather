//
//  ForecastAI.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-12.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class ForecastAI {

    func getWeatherConditionFromText(text: String) -> WeatherCondition {
        let lowerCaseText = text.lowercaseString
        if lowerCaseText.containsString("cloud") && lowerCaseText.containsString("sun") {
            return WeatherCondition.SunnyCloudy
        } else if lowerCaseText.containsString("sun") && lowerCaseText.containsString("rain") {
            return WeatherCondition.Sunshower
        } else if lowerCaseText.containsString("tornado") || (lowerCaseText.containsString("high") && lowerCaseText.containsString("wind")) {
            return WeatherCondition.Tornado
        } else if lowerCaseText.containsString("snow") || lowerCaseText.containsString("ice") || lowerCaseText.containsString("flurr")  || lowerCaseText.containsString("cold") {
            return WeatherCondition.Snowy
        } else if lowerCaseText.containsString("wind") {
            return WeatherCondition.Windy
        } else if lowerCaseText.containsString("lighting") {
            return WeatherCondition.Lightning
        } else if lowerCaseText.containsString("cloud") {
            return WeatherCondition.Cloudy
        } else if lowerCaseText.containsString("rain"){
            return WeatherCondition.Rainy
        } else if lowerCaseText.containsString("sun") {
            return WeatherCondition.Sunny
        }
        return WeatherCondition.Error
    }
    
}