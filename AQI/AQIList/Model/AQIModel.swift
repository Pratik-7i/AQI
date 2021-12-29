//
//  AQIListModel.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import Foundation

class ResponseModel: Codable
{
    var cityName : String
    var cityAqi  : Double

    private enum CodingKeys: String, CodingKey {
        case cityName = "city"
        case cityAqi = "aqi"
    }
}

class CityModel
{
    var name       : String
    var aqiHistory = [AQIModel]()
    
    init(_ name: String) {
        self.name = name
    }
}

class AQIModel
{
    var aqi      : Double
    var category : AQICategory
    var time     : Date
    
    init(_ responseModel: ResponseModel) {
        self.aqi = responseModel.cityAqi
        self.category = AQICategory(rawValue: responseModel.cityAqi)
        self.time = Date()
    }
}
