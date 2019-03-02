//
//  ForecastEntity+CoreDataClass.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ForecastEntity)
public class ForecastEntity: NSManagedObject {
    
    
    class func fetchForecast(forCityId id: Int64) -> [ForecastEntity] {
        return ForecastEntity.query(["city.id": id], sort: [["date": "ASC"]]) as! [ForecastEntity]
    }
    
    class func removeForecasts(forCity city: CityEntity) {
        let forecasts = ForecastEntity.query(["city.id": city.id])
        for forecast in forecasts {
            forecast.delete()
            _ = forecast.save()
        }
    }
    
    class func create(_ json: [[String: Any]], city: CityEntity) {
        for object in json {
            guard let date = object["dt"] as? Int64 else {
                continue
            }
            
            let entity = ForecastEntity.create()
            guard let forecastEntity = entity as? ForecastEntity else {
                continue
            }
            
            forecastEntity.date = date
            guard let main = object["main"] as? [String: Any] else {
                continue
            }
            if let temperature = main["temp"] as? Double {
                forecastEntity.temperature = temperature
            }
            if let minTemperature = main["temp_min"] as? Double {
                forecastEntity.minimumTemperature = minTemperature
            }
            if let maxTemperature = main["temp_max"] as? Double {
                forecastEntity.maximumTemperature = maxTemperature
            }
            
            if let pressure = main["pressure"] as? Double {
                forecastEntity.pressure = pressure
            }
            if let sealLevel = main["sea_level"] as? Double {
                forecastEntity.seaLevel = sealLevel
            }
            if let groundLevel = main["grnd_level"] as? Double {
                forecastEntity.groundLevel = groundLevel
            }
            if let humidity = main["humidity"] as? Int16 {
                forecastEntity.humidity = humidity
            }
            forecastEntity.city = city
            
            if let clouds = object["clouds"] as? [String: Any] {
                if let cloudiness = clouds["all"] as? Int16 {
                    if let cloudEntity = CloudEntity.create() as? CloudEntity {
                        cloudEntity.cloudiness = cloudiness
                        forecastEntity.cloud = cloudEntity
                    }
                }
            }
            
            if let wind = object["wind"] as? [String: Any] {
                if let speed = wind["speed"] as? Double {
                    if let degree = wind["deg"] as? Double {
                        if let windEntity = WindEntity.create() as? WindEntity {
                            windEntity.speed = speed
                            windEntity.degree = degree
                            forecastEntity.wind = windEntity
                        }
                    }
                }
            }
            
            
            if let rain = object["rain"] as? [String: Any] {
                if let volume = rain["volume"] as? Double {
                    if let rainEntity = RainEntity.create() as? RainEntity {
                        rainEntity.volume = volume
                        forecastEntity.rain = rainEntity
                    }
                }
            }
            
            if let snow = object["snow"] as? [String: Any] {
                if let volume = snow["volume"] as? Double {
                    if let snowEntity = SnowEntity.create() as? SnowEntity {
                        snowEntity.volume = volume
                        forecastEntity.snow = snowEntity
                    }
                }
            }
            
            if let weathers = object["weather"] as? [[String: Any]] {
                for weather in weathers {
                    guard let id = weather["id"] as? Int16 else {
                        continue
                    }
                    
                    guard let main = weather["main"] as? String else {
                        continue
                    }
                    
                    guard let desc = weather["description"] as? String else {
                        continue
                    }
                    
                    guard let icon = weather["icon"] as? String else {
                        continue
                    }
                    
                    if let weatherEntity = WeatherEntity.create() as? WeatherEntity {
                        weatherEntity.id = id
                        weatherEntity.main = main
                        weatherEntity.desc = desc
                        weatherEntity.icon = icon
                        forecastEntity.addToWeather(weatherEntity)
                    }
                }
            }
            
            _ = forecastEntity.save()
        }
    }
    
}
