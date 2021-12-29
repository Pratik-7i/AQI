//
//  AQIListViewModel.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import Foundation
import Starscream

protocol SocketDelegate: AnyObject {
    func socketStatuDidUpdate(isConnected: Bool, error: String?)
}

protocol AQIListDelegate: AnyObject {
    func didUpdateAQIData()
}

protocol AQIChartDelegate: AnyObject {
    func didUpdateSelectedCityAQI()
}

class AQIListViewModel
{
    var isConnected = false
    
    private var socket: WebSocket = {
        let url = URL(string: serverURL)!
        let urlRequest = URLRequest(url: url)
        let webSocket = WebSocket(request: urlRequest)
        return webSocket
    }()
    
    weak var socketDelegate: SocketDelegate?
    weak var listDelegate: AQIListDelegate?
    weak var chartDelegate: AQIChartDelegate?

    var cityAQIArray = [CityModel]()
    var selectedCityModel : CityModel?
    
    func connectSocket() {
        if !self.isConnected {
            self.socket.connect()
        }
    }
    
    func disconnectSocket() {
        self.socket.disconnect()
    }
    
    func startObservingAQIData() {
        self.socket.delegate = self
        self.socket.connect()
    }
    
    func parseResponse(_ string: String)
    {
        guard let data = string.data(using: .utf8) else {
            print("Invalid Response from server.")
            return
        }
        do {
            let responseArray = try JSONDecoder().decode([ResponseModel].self, from: data)
            self.prepareDatasource(responseArray)
        } catch {
            print(error)
        }
    }
    
    func prepareDatasource(_ responseArray: [ResponseModel])
    {
        // Iterate through array and check whether city already exists. If exists, append AQI value.
        for responseModel in responseArray {
            let aqiModel = AQIModel(responseModel)
            if let cityModel = self.cityAQIArray.filter({$0.name == responseModel.cityName}).first {
                if cityModel.aqiHistory.count >= 20 { cityModel.aqiHistory.removeFirst() }
                cityModel.aqiHistory.append(aqiModel)
            } else {
                let cityModel = CityModel(responseModel.cityName)
                cityModel.aqiHistory.append(aqiModel)
                self.cityAQIArray.append(cityModel)
            }
        }
        
        // Sort array based on city name.
        self.cityAQIArray.sort { $0.name < $1.name }
        
        // Notify the city list View.
        if let delegate = self.listDelegate {
            delegate.didUpdateAQIData()
        }
        
        // Notify the chart ViewModel if there is an update for selected city.
        if let selectedCityModel = self.selectedCityModel, responseArray.contains(where: { $0.cityName == selectedCityModel.name }) {
            if let delegate = self.chartDelegate {
                delegate.didUpdateSelectedCityAQI()
            }
        }
    }
    
    func handleSocketError(_ error: Error?)
    {
        var errorMessage = ""
        if let err = error as? WSError {
            errorMessage = Message.webSocketError + ": " + err.message
        } else if let err = error {
            errorMessage = Message.webSocketError + ": " + err.localizedDescription
        } else {
            errorMessage = Message.webSocketError
        }
        if let delegate = self.socketDelegate {
            delegate.socketStatuDidUpdate(isConnected: false, error: errorMessage)
        }
    }
}

extension AQIListViewModel: WebSocketDelegate
{
    func didReceive(event: WebSocketEvent, client: WebSocket)
    {
        switch event
        {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            self.isConnected = true
            if let delegate = self.socketDelegate {
                delegate.socketStatuDidUpdate(isConnected: true, error: nil)
            }
            
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            self.isConnected = false
            if let delegate = self.socketDelegate {
                delegate.socketStatuDidUpdate(isConnected: false, error: reason)
            }
            
        case .text(let string):
            self.parseResponse(string)
            
        case .binary(let data):
            print("Received data: \(data.count)")
            
        case .ping(_):
            break
            
        case .pong(_):
            break
            
        case .viabilityChanged(_):
            print("viabilityChanged")
            break
            
        case .reconnectSuggested(_):
            print("reconnectSuggested")
            break
            
        case .cancelled:
            print("cancelled")
            self.isConnected = false
            
        case .error(let error):
            self.isConnected = false
            self.handleSocketError(error)
        }
    }
}
