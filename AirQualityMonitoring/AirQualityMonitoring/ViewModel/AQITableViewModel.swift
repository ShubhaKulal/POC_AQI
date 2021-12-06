//
//  AQITableViewModel.swift
//  AirQualityMonitoring
//
//  Created by techjini on 03/12/21.
//

import Foundation

class AQITableViewModel: AQIBaseViewModel {
    
    func numberOfRows(inSection section: Int) -> Int {
        return defaultCitiesList.count
    }
}

