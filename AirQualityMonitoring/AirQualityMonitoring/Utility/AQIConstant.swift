//
//  AQIConstant.swift
//  AirQualityMonitoring
//
//  Created by techjini on 03/12/21.
//

import Foundation

enum Const {
    static let good = "Good"
    static let satisfactory = "Satisfcatory"
    static let moderate = "Moderate"
    static let poor = "Poor"
    static let veryPooor = "VeryPoor"
    static let severe = "Severe"
    static let airQualityIndex = "AIR QUALITY INDEX"
    
    static let socketUrl = "ws://city-ws.herokuapp.com"
    
    enum city {
        static let delhi = "Delhi"
        static let mumbai = "Mumbai"
        static let kolkata = "Kolkata"
        static let bengaluru = "Bengaluru"
        static let chennai = "Chennai"
        static let hyderabad = "Hyderabad"
        static let pune = "Pune"
    }
}
