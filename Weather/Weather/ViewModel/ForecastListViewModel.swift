//
//  ForecastListViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

enum ForecastViewType: Int {
    case charts = 1
    case list = 2
}

enum ForecastType: Int {
    case temperature = 1
    case wind = 2
    case pressure = 3
}

enum ForecastUnit: String {
    case temperature = "°C"
    case wind = "m/s"
    case pressure = "hpa"
}


class ForecastListViewModel {
    private var _forecastViewModels: [ForecastViewModel] = []
    private let dataProvider = DataProvider()
    
    var didUpdate: (()->())? = nil
    var didFail: ((WeatherError?)->())? = nil

    /** Forecast type, used to update the UI */
    var forecastType: ForecastType = .temperature {
        didSet {
            
            switch forecastType {
            case .temperature:
                _chartUnit = .temperature
            case .wind:
                _chartUnit = .wind
            case .pressure:
                _chartUnit = .pressure
            }
            
            if forecastType != oldValue {
                self.didUpdate?()
            }
        }
    }
    
    
    /** forecast view type, used to update the UI */
    var forecastViewType: ForecastViewType = .charts {
        didSet {
            if forecastViewType != oldValue {
                self.didUpdate?()
            }
            
        }
    }
    
    private var _chartUnit: ForecastUnit = .temperature
    var chartUnit: ForecastUnit {
        return _chartUnit
    }
    
    
    /** Grouping of the forecast based on date */
    private var _groupedViewModels: Dictionary<Int64, [ForecastViewModel]> {
        return Dictionary(grouping: _forecastViewModels, by: { $0.absoluteDate })
    }
    
    /** Total groups of forecast according to date */
    var groupedCount: Int{
        return _groupedViewModels.keys.count
    }
    
    /** forecast view type title */
    var switchToViewTypeTitle: String {
        if forecastViewType == .charts {
            return "List"
        } else {
            return "Chart"
        }
    }
    
    
    /** Fetch forecast from data provider */
    func fetchForecasts(with city: CityViewModel){
        dataProvider.fetchForecastData(for: city.id, lastFetch: city.lastFetch) { [weak self] (forecastEntities, weatherError) in
            guard let weakSelf = self else {
                return
            }
            if let error = weatherError {
                weakSelf.didFail?(error)
                return
            }
            
            guard let forecasts = forecastEntities else {
                weakSelf.didFail?(WeatherError.emptyResponse)
                return
            }
            weakSelf._forecastViewModels = DataModelParser.parse(forecastEntities: forecasts).map{ForecastViewModel(with: $0)}
            weakSelf.didUpdate?()
        }
    }
    
    
    /** Fetch all forecast */
    func all()-> [ForecastViewModel] {
        return _forecastViewModels
    }
    
    
    /** Switch forecast view type */
    func switchViewType() {
        if forecastViewType == .charts {
            forecastViewType = .list
        } else {
            forecastViewType = .charts
        }
    }

    /** Fetch the count for forecast in specific group */
    func groupedViewModelCount(for section: Int) -> Int {
        let arrKeys = Array(_groupedViewModels.keys).sorted()
        if arrKeys.count > section {
            guard let forecasts = _groupedViewModels[arrKeys[section]] else {
                return 0
            }
            return forecasts.count
        }
        return 0
    }
    
    /** fetch the forecast from specifc group section and row */
    func groupedViewModel(at section: Int, row: Int) -> ForecastViewModel? {
        let arrKeys = Array(_groupedViewModels.keys).sorted()
        if arrKeys.count > section {
            guard let forecasts = _groupedViewModels[arrKeys[section]] else {
                return nil
            }
            if forecasts.count > row {
                return forecasts[row]
            }
        }
        return nil
        
    }
    
    /** fetch group and section */
    func group(at section: Int) -> Int64? {
        let arr = Array(_groupedViewModels.keys).sorted()
        if arr.count > section {
            return Array(_groupedViewModels.keys).sorted()[section]
        }
        return nil
    }
}
