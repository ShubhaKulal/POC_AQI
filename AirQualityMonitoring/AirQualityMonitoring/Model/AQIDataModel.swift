//
//  AQIDataModel.swift
//  AirQualityMonitoring
//
//  Created by techjini on 01/12/21.
//

import Foundation
import UIKit


enum AQILevel: Int {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe

    init?(rawValue: Int) {
        switch rawValue {
        case 0 ... 50: self = .good
        case 51 ... 100: self = .satisfactory
        case 101 ... 200: self = .moderate
        case 201 ... 300: self = .poor
        case 301 ... 400: self = .veryPoor
        case 401 ... 500: self = .severe
        default: return nil
        }
    }
}

extension AQILevel {
    
    var displayString: String {
        switch self {
        case .good : return Const.good
        case .satisfactory : return Const.satisfactory
        case .moderate : return Const.moderate
        case .poor : return Const.poor
        case .veryPoor : return Const.veryPooor
        case .severe : return Const.severe
        }
    }

    var color: UIColor {
        switch self {
        case .good:
            return UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        case .satisfactory:
            return UIColor(red: 148.0/255.0, green: 192.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .moderate:
            return UIColor(red: 254.0/255.0, green: 250.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        case .poor:
            return UIColor(red: 236.0/255.0, green: 138.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        case .veryPoor:
            return UIColor(red: 225.0/255.0, green: 40.0/2550.0, blue: 39.0/255.0, alpha: 1.0)
        case .severe:
            return UIColor(red: 157.0/255.0, green: 28.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
}

// MARK: - AQIData
struct AQIData: Codable {
    let city: String
    let aqi: Double
    // used to fill time stamp when we get the data.
    let updated = Date()

    enum CodingKeys: String, CodingKey {
        case city
        case aqi
    }
}

typealias AQIList = [AQIData]

extension AQIData: Equatable {
    static func == (lhs: AQIData, rhs: AQIData) -> Bool {
        return lhs.city == rhs.city
    }
}

extension AQIData: Comparable {
    static func < (lhs: AQIData, rhs: AQIData) -> Bool {
        return lhs.city < rhs.city
    }
}

extension AQIData: AQITableCellViewModel {
    
    var updatedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let string = formatter.localizedString(for: updated, relativeTo: Date())
        if(string.contains("0 seconds")) {
            return "Few seconds ago"
        }
         return string
    }
    
    var backgroundColor: UIColor? {
        let quality = AQILevel(rawValue: Int(aqi))
        return quality?.color
    }
    
    var cityName: String {
        return city
    }
    
    var aqiValue: String {
        return String(format: "%.2f", aqi)
    }
}
