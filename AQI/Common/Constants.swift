//
//  Constants.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import Foundation
import UIKit

let serverURL = "ws://city-ws.herokuapp.com/"

struct Color
{
    struct AQICategory
    {
        static let good         = UIColor(named: "good")         ?? .white
        static let satisfactory = UIColor(named: "satisfactory") ?? .white
        static let moderate     = UIColor(named: "moderate")     ?? .white
        static let poor         = UIColor(named: "poor")         ?? .white
        static let veryPoor     = UIColor(named: "veryPoor")     ?? .white
        static let severe       = UIColor(named: "severe")       ?? .white
        static let unknown      = UIColor(named: "unknown")      ?? .white
    }
}

struct Message
{
    static let airQualityName = "Air quality is "
    static let webSocketError = "Websocket encountered an error"
}
