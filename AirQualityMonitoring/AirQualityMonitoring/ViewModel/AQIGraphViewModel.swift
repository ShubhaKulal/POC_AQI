//
//  AQIGraphViewModel.swift
//  AirQualityMonitoring
//
//  Created by techjini on 03/12/21.
//

import Foundation


class AQIGraphViewModel: AQIBaseViewModel {
    
    override func updateLatestAQI() {
        if let filteredList = filterDefault(cities: cityList, from: displayCityList), !filteredList.isEmpty {
            replaceAQIValuesInDefaultList(filteredList)
            delegate?.viewModelDidUpdate()
        }
    }
}
