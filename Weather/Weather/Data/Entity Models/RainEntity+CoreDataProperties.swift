//
//  RainEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension RainEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RainEntity> {
        return NSFetchRequest<RainEntity>(entityName: "RainEntity")
    }

    @NSManaged public var volume: Double
    @NSManaged public var forecast: ForecastEntity?

}
