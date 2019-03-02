//
//  WeatherChartView.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import Charts

class WeatherChartView: LineChartView {
    
    private lazy var dateValueFormatter = DateValueFormatter()
    private lazy var temperatureValueFormatter = TemperatureValueFormatter()
    private lazy var windValueFormatter = WindValueFormatter()
    private lazy var pressureValueFormatter = PressureValueFormatter()
    
    var forecastListModel: ForecastListViewModel!
    var themeColor: UIColor = .blue
    var unit: String = "" {
        didSet {
            refreshChartData()
        }
    }
    
    /** configure chart */
    func configure() {
        
        noDataText = "No data available"
        noDataTextColor = UIColor.lightGray
        dragEnabled = true
        setScaleEnabled(true)
        pinchZoomEnabled = false
        highlightPerDragEnabled = true
        legend.enabled = false
        leftAxis.enabled = true
        rightAxis.enabled = false
        chartDescription?.enabled = false
        
        configureXAxis()
        configureYAxis()
        configureMarker()
        
    }
    
    /** configure XAxis of chart */
    private func configureXAxis(){
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularityEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.gridColor = UIColor.gray
        xAxis.labelTextColor = UIColor.black
        xAxis.drawLimitLinesBehindDataEnabled = true
    }
    
    /** configure Y axis of chart */
    private func configureYAxis() {
        leftAxis.granularityEnabled = true
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.gridColor = UIColor.lightGray
        leftAxis.labelTextColor = UIColor.black
        leftAxis.valueFormatter = temperatureValueFormatter
    }
    
    /** Configure marker */
    private func configureMarker() {
        let bMarker = BalloonMarker(color: UIColor.darkGray,
                                   font: .systemFont(ofSize: 12, weight: .bold),
                                   textColor: UIColor.white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        bMarker.chartView = self
        bMarker.minimumSize = CGSize(width: 80, height: 40)
        marker = bMarker
        
    }
    
    //MARK:- UI
    
    /** Refresh hart's data */
    func refreshChartData() {
        if let bMarker = marker as? BalloonMarker {
            bMarker.unit = unit
        }
        switch forecastListModel.forecastType {
        case .temperature:
            leftAxis.valueFormatter = temperatureValueFormatter
            
        case .wind:
            leftAxis.valueFormatter = windValueFormatter
        case .pressure:
            leftAxis.valueFormatter = pressureValueFormatter
        }
        data = getChartData()
        animate(xAxisDuration: 0.5)
    }
    
    /** get chart data based on data sets */
    private func getChartData() -> ChartData {
        let data = LineChartData(dataSets: getChartDataSets())
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        return data
    }
    
    /** get charts datasets based on forecast type */
    private func getChartDataSets()-> [LineChartDataSet] {
        switch forecastListModel.forecastType {
        case .temperature:
            let temperatureData = forecastListModel.all().map { (forecast) -> ChartDataEntry in
                return ChartDataEntry(x: Double(forecast.date), y: forecast.temperature)
            }
            return [createDataSet(entries: temperatureData, color: themeColor)]
            
        case .wind:
            let windData = forecastListModel.all().compactMap{ (forecast) -> ChartDataEntry? in
                guard let wind = forecast.windSpeed else {
                    return nil
                }
                return ChartDataEntry(x: Double(forecast.date), y: wind)
            }
            
            return [createDataSet(entries: windData, color: themeColor)]
            
        case .pressure:
            let pressureData = forecastListModel.all().compactMap{ (forecast) -> ChartDataEntry? in
                guard let pressure = forecast.pressure else {
                    return nil
                }
                return ChartDataEntry(x: Double(forecast.date), y: pressure)
            }
            return [createDataSet(entries: pressureData, color: themeColor)]
        }
        
    }
    
    /** create chart data set based on data entry */
    private func createDataSet(entries: [ChartDataEntry], color: UIColor) -> LineChartDataSet {
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.setCircleColor(color)
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.fillAlpha = 0.5
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        return dataSet
    }
    
}


//MARK:-
class DateValueFormatter: NSObject, IAxisValueFormatter {
    
    private var dateFormatter: DateFormatter?
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "d MMM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let epoch = TimeInterval(exactly: value) {
            let date = Date(timeIntervalSince1970: epoch)
            if let string = dateFormatter?.string(from: date) {
                return string
            }
        }
        return ""
    }
}

//MARK:-
class TemperatureValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.format(f: ".1") + ForecastUnit.temperature.rawValue
    }
}

//MARK:-
class PressureValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.format(f: ".0") + " " + ForecastUnit.pressure.rawValue
    }
}

//MARK:-
class WindValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.format(f: ".1") + " " + ForecastUnit.wind.rawValue
    }
}
