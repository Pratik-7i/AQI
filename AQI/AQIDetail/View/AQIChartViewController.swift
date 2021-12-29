//
//  AQIChartViewController.swift
//  AQI
//
//  Created by Pratik on 23/12/21.
//

import UIKit
import Starscream
import Charts

class AQIChartViewController: UIViewController
{
    @IBOutlet var chartView: LineChartView!

    lazy var viewModel : AQIChartViewModel = {
        let viewModel = AQIChartViewModel()
        viewModel.refreshDelegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.setupChart()
        self.viewModel.prepareChartDatasource()
    }
    
    func setupControls() {
        if let cityModel = self.viewModel.cityModel {
            self.title = cityModel.name
        }
    }
    
    func setupChart()
    {
        self.chartView.chartDescription.enabled = false
        self.chartView.dragEnabled = true
        self.chartView.setScaleEnabled(true)
        self.chartView.pinchZoomEnabled = true
        self.chartView.rightAxis.enabled = false
        self.chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.chartView.legend.enabled = false
        
        let xAxis = self.chartView.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelRotationAngle = -60
        
        let leftAxis = self.chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 500
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineDashLengths = [5, 5]
    }
}

extension AQIChartViewController: AQIRefreshChartDelegate
{
    func refreshChart() {
        self.chartView.data = self.viewModel.chartData
        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.viewModel.dataPoints)
        if let data = self.chartView.data {
            data.notifyDataChanged()
            self.chartView.notifyDataSetChanged()
        }
    }
}
