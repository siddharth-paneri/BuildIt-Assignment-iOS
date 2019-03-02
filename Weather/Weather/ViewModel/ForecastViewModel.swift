//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation



class ForecastViewModel {
    
    private var _forecastDataModel: ForecastDataModel
    
    init(with models: ForecastDataModel) {
        _forecastDataModel = models
    }
    
    var didUpdate: (()->())? = nil
    var didFail: ((WeatherError?)->())? = nil
    
    
    /** Provides date of forecast */
    var date: Int64 {
        return _forecastDataModel.date
    }
    
    /** Provides absolute date (start of day) of a forecast */
    var absoluteDate: Int64 {
        return _forecastDataModel.absoluteDate
    }
    
    /** Provides temperature of a forecast */
    var temperature: Double {
        return _forecastDataModel.temperature
    }
    
    /** Provides temperature string value with unit of a forecast */
    var temperatureValue: String {
        return temperature.format(f: ".1") + ForecastUnit.temperature.rawValue
    }
    
    /** Provides minimum temperature of a forecast */
    var minTemperature: Double? {
        return _forecastDataModel.minTemperature
    }
    /** Provides min temperature with unit of a forecast */
    var minTemperatureValue: String {
        guard let temp = minTemperature else {
            return ""
        }
        return temp.format(f: ".1") + ForecastUnit.temperature.rawValue
    }
    
    /** Provides max temperature of a forecast */
    var maxTemperature: Double? {
        return _forecastDataModel.maxTemperature
    }
    /** Provides max temperature with unit of a forecast */
    var maxTemperatureValue: String {
        guard let temp = maxTemperature else {
            return ""
        }
        return temp.format(f: ".1") + ForecastUnit.temperature.rawValue
    }
    
    /** Provides wind speed fo a forecast */
    var windSpeed: Double? {
        return _forecastDataModel.wind?.speed
    }
    /** Provides wind speed with unit of a forecast */
    var windSpeedValue : String {
        guard let speed = windSpeed else {
            return ""
        }
        return speed.format(f: ".1") + " " + ForecastUnit.wind.rawValue
    }
    
    /** Provides wind degree of a forecast */
    var windDegree: Double? {
        return _forecastDataModel.wind?.degree
    }
    
    /** Provides pressure of a forecast */
    var pressure: Double? {
        return _forecastDataModel.pressure
    }
    /** Provides pressure with unit of a forecats */
    var pressureValue: String {
        guard let pres = pressure else {
            return ""
        }
        return pres.format(f: ".1") + " " + ForecastUnit.wind.rawValue
    }
    
    /** Provides time string of a forecast */
    var timeString: String {
        return Config.shared.getTimeString(timeInterval: TimeInterval(date))
    }
    
    /** Provides date string of a forecast */
    var dateString: String {
        return Config.shared.getDateString(timeInterval: TimeInterval(date))
    }
 
    /** Provides image url for a forecast */
    var imageUrl: URL? {
        guard let weathers = _forecastDataModel.weather else {
            return nil
        }
        
        if weathers.count > 0 {
            let weather = weathers[0]
            return URL(string: BASE_URL_IMAGE + weather.icon + ".png")
        }
        
        return nil
    }
    
}
