//
//  AQIDataViewModel.swift
//  AirQualityMonitoring
//
//  Created by techjini on 02/12/21.
//

import Foundation
import Starscream

protocol ViewModelDelegate: AnyObject {
    func viewModelDidUpdate()
}

class AQIBaseViewModel {
    
    var cityList = [Const.city.delhi,Const.city.mumbai, Const.city.kolkata,Const.city.bengaluru,Const.city.chennai, Const.city.hyderabad,Const.city.pune]
    
    private var socket: WebSocket = {
        let url = URL(string:Const.socketUrl)!
        let urlRequest = URLRequest(url: url)
        let webSocket = WebSocket(request: urlRequest)
        return webSocket
    }()
    
    weak var delegate: ViewModelDelegate?
    
    init(with citiesList: [String]) {
        self.cityList = citiesList
    }
    
    var displayCityList: AQIList = [] {
        didSet {
            updateLatestAQI()
        }
    }
    
    lazy var defaultCitiesList: AQIList = {
        var list: AQIList = []
        for element in cityList {
            let aqi = AQIData(city: element, aqi: 0.0)
            list.append(aqi)
        }
        return list
    }()
    
    func filterDefault(cities cityList: [String], from aqiList: AQIList) -> AQIList? {
        let filteredList = aqiList.filter {cityList.contains($0.city)}
        return filteredList
    }
    
    func replaceAQIValuesInDefaultList(_ filteredList: AQIList) {
        for aqiData in filteredList {
            if let index = defaultCitiesList.firstIndex(of: aqiData) {
                defaultCitiesList[index] = aqiData
            }
        }
    }
    
    func updateLatestAQI() {
        if let filteredList = filterDefault(cities: cityList, from: displayCityList) {
            replaceAQIValuesInDefaultList(filteredList)
        }
        delegate?.viewModelDidUpdate()
    }
    
    private func handleAQI(data: Data) {
        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(AQIList.self, from: data)
            self.displayCityList = item
        } catch {
        }
    }
}

extension AQIBaseViewModel {
    
    func startSocketConnection() {
        // Start the socket connection
        socket.delegate = self
        socket.connect()
    }
    
    func stopScoketConnection() {
        // Stop the socket connection
        socket.disconnect()
        socket.delegate = nil
    }
}

extension AQIBaseViewModel: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let data = Data(string.utf8)
            self.handleAQI(data: data)
            print("Received text: \(string)")
        case .error(let error):
            print(error ?? "")
            break
        default:
            break
        }
    }
}
