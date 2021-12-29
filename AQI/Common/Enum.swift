
import Foundation
import UIKit

public enum AQICategory: Int
{
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case unknown
    
    public static var `default`: AQICategory { return .unknown }

    init(rawValue: Double)
    {
        if rawValue      >= 401 { self = .severe }
        else if rawValue >= 301 { self = .veryPoor }
        else if rawValue >= 201 { self = .poor }
        else if rawValue >= 101 { self = .moderate }
        else if rawValue >= 51  { self = .satisfactory }
        else                    { self = .good }
    }
    
    var name: String
    {
        switch self
        {
        case .good         : return "Good"
        case .satisfactory : return "Satisfactory"
        case .moderate     : return "Moderate"
        case .poor         : return "Poor"
        case .veryPoor     : return "Very poor"
        case .severe       : return "Severe"
        case .unknown      : return "Unknown"
        }
    }
    
    var color: UIColor
    {
        switch self
        {
        case .good         : return Color.AQICategory.good
        case .satisfactory : return Color.AQICategory.satisfactory
        case .moderate     : return Color.AQICategory.moderate
        case .poor         : return Color.AQICategory.poor
        case .veryPoor     : return Color.AQICategory.veryPoor
        case .severe       : return Color.AQICategory.severe
        case .unknown      : return Color.AQICategory.unknown
        }
    }
}
