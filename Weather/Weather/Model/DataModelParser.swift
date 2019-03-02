//
//  DataModelParser.swift
//  Weather
//
//  Created by Siddharth Paneri on 02/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


class DataModelParser {
    class func parse(cityEntity: CityEntity) -> CityDataModel? {
        guard let name = cityEntity.name else {
            return nil
        }
        guard let country = cityEntity.country else {
            return nil
        }
        
        var forecastData: [ForecastDataModel] = []
        if let forecasts = cityEntity.forecasts?.allObjects as? [ForecastEntity] {
            for forecast in forecasts {
                forecastData.append(DataModelParser.parse(forecastEntity: forecast))
            }
        }
        
        return CityDataModel.init(id: cityEntity.id, name: name, country: country, latitude: cityEntity.latitude, longitude: cityEntity.longitude, forecasts: forecastData, lastUpdateTimestamp: cityEntity.lastUpdateTimestamp)
    }
    
    class func parse(cityEntities: [CityEntity]) -> [CityDataModel] {
        var cityDataModels: [CityDataModel] = []
        for entity in cityEntities {
            if let model = DataModelParser.parse(cityEntity: entity) {
                cityDataModels.append(model)
            }
        }
        return cityDataModels
    }
    
    class func parse(forecastEntity: ForecastEntity) -> ForecastDataModel {
        
        let temperature = forecastEntity.temperature
        let minTemperature = forecastEntity.minimumTemperature
        let maxTemperature = forecastEntity.maximumTemperature
        let pressure = forecastEntity.pressure
        let humidity = forecastEntity.humidity
        let seaLevel = forecastEntity.seaLevel
        let groundLevel = forecastEntity.groundLevel
        let date = forecastEntity.date
        
        
        var weatherDataModels: [WeatherDataModel] = []
        if let weathers = forecastEntity.weather?.allObjects as? [WeatherEntity] {
            for weather in weathers {
                let id = weather.id
                guard let name = weather.main else {
                    continue
                }
                guard let description = weather.desc else {
                    continue
                }
                guard let icon = weather.icon else {
                    continue
                }
                
                weatherDataModels.append(WeatherDataModel.init(id: id, name: name, description: description, icon: icon))
            }
        }
        
        var cloudDataModel: CloudDataModel? = nil
        if let cloudiness = forecastEntity.cloud?.cloudiness {
            cloudDataModel = CloudDataModel.init(cloudiness: cloudiness)
        }
        
        
        var windDataModel: WindDataModel? = nil
        if let windEntity = forecastEntity.wind {
            windDataModel = WindDataModel.init(speed: windEntity.speed, degree: windEntity.degree)
        }
        
        
        var rainDataModel: RainDataModel? = nil
        if let rainEntity = forecastEntity.rain {
            rainDataModel = RainDataModel.init(volume: rainEntity.volume)
        }
        
        
        var snowDataModel: SnowDataModel? = nil
        if let snowEntity = forecastEntity.snow {
            snowDataModel = SnowDataModel.init(volume: snowEntity.volume)
        }
        
        var calendar = Calendar.current
        if let utc = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = utc
        }
        let components = calendar.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: TimeInterval(date)))
        var absoluteDate = date
        if let absDate = calendar.date(from: components) {
            absoluteDate = Int64(absDate.timeIntervalSince1970)
        }
        
        return ForecastDataModel.init(temperature: temperature, minTemperature: minTemperature, maxTemperature: maxTemperature, pressure: pressure, humidity: humidity, seaLevel: seaLevel, groundLevel: groundLevel, date: date, absoluteDate: absoluteDate, weather: weatherDataModels, cloud: cloudDataModel, wind: windDataModel, rain: rainDataModel, snow: snowDataModel)
        
    }
    
    
    class func parse(forecastEntities: [ForecastEntity]) -> [ForecastDataModel] {
        var forecastDataModels: [ForecastDataModel] = []
        for entity in forecastEntities {
            forecastDataModels.append(DataModelParser.parse(forecastEntity: entity))
        }
        return forecastDataModels
    }
}
