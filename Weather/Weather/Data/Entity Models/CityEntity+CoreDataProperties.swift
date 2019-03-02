//
//  CityEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension CityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var lastUpdateTimestamp: Int64
    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension CityEntity {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: ForecastEntity)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: ForecastEntity)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}
