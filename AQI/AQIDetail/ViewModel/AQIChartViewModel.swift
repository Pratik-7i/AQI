//
//  AQIChartViewModel.swift
//  AQI
//
//  Created by Pratik on 23/12/21.
//

import Foundation
import UIKit
import Charts

protocol AQIRefreshChartDelegate: AnyObject {
    func refreshChart()
}

class AQIChartViewModel {
    var cityModel : CityModel?
    var chartData: ChartData?
    var circleColors = [NSUIColor]()
    var dataPoints = [String]()
    weak var refreshDelegate: AQIRefreshChartDelegate?
}

extension AQIChartViewModel: AQIChartDelegate
{
    func didUpdateSelectedCityAQI() {
        self.prepareChartDatasource()
    }
    
    func prepareChartDatasource()
    {
        guard let cityModel = self.cityModel else { return }
        
        self.circleColors = cityModel.aqiHistory.map({ $0.category.color })
        self.dataPoints = cityModel.aqiHistory.map({ $0.time.readable(format: "h:mm a") })
        
        let values = cityModel.aqiHistory.enumerated().map { (index, model) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: Double(model.aqi))
        }
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor, ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        let dataset = LineChartDataSet(entries: values, label: "AQI")
        dataset.drawIconsEnabled = false
        dataset.fillAlpha = 1
        dataset.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataset.drawFilledEnabled = true
        dataset.drawValuesEnabled = false
        dataset.lineWidth = 1
        dataset.circleRadius = 3
        dataset.gradientPositions = [0, 40, 100]
        dataset.isDrawLineWithGradientEnabled = true
        dataset.mode = .horizontalBezier
        dataset.circleColors = self.circleColors
        dataset.colors = [.secondaryLabel]
        self.chartData = LineChartData(dataSet: dataset)

        if let delegate = self.refreshDelegate {
            delegate.refreshChart()
        }
    }
}


