//
//  ForecastDataModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


struct ForecastDataModel {
    var temperature: Double
    var minTemperature: Double?
    var maxTemperature: Double?
    var pressure: Double?
    var humidity: Int16?
    var seaLevel: Double?
    var groundLevel: Double?
    var date: Int64
    var absoluteDate: Int64
    
    var weather: [WeatherDataModel]?
    var cloud: CloudDataModel?
    var wind: WindDataModel?
    var rain: RainDataModel?
    var snow: SnowDataModel?
}

struct WeatherDataModel {
    var id: Int16
    var name: String
    var description: String?
    var icon: String
}
struct CloudDataModel {
    var cloudiness: Int16
}
struct WindDataModel {
    var speed: Double
    var degree: Double
}
struct RainDataModel {
    var volume: Double
}
struct SnowDataModel {
    var volume: Double
}

