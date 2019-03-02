//
//  ForecastEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var date: Int64
    @NSManaged public var groundLevel: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var maximumTemperature: Double
    @NSManaged public var minimumTemperature: Double
    @NSManaged public var pressure: Double
    @NSManaged public var seaLevel: Double
    @NSManaged public var temperature: Double
    @NSManaged public var cloud: CloudEntity?
    @NSManaged public var rain: RainEntity?
    @NSManaged public var snow: SnowEntity?
    @NSManaged public var weather: NSSet?
    @NSManaged public var wind: WindEntity?
    @NSManaged public var city: CityEntity?

}

// MARK: Generated accessors for weather
extension ForecastEntity {

    @objc(addWeatherObject:)
    @NSManaged public func addToWeather(_ value: WeatherEntity)

    @objc(removeWeatherObject:)
    @NSManaged public func removeFromWeather(_ value: WeatherEntity)

    @objc(addWeather:)
    @NSManaged public func addToWeather(_ values: NSSet)

    @objc(removeWeather:)
    @NSManaged public func removeFromWeather(_ values: NSSet)

}
