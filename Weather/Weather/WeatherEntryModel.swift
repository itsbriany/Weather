//
//  WeatherEntryModel.swift
//  Weather
//
//  Created by Brian Yip on 2016-02-11.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

public struct WeatherEntryModel {
    var summary: String?
    var title: String?
    
    init(summary: String, title: String) {
        self.summary = summary
        self.title = title
    }
    
    init() {
        self.summary = nil
        self.title = nil
    }
}