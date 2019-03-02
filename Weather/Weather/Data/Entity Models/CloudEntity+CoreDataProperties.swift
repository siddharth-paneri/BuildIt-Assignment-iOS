//
//  CloudEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension CloudEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudEntity> {
        return NSFetchRequest<CloudEntity>(entityName: "CloudEntity")
    }

    @NSManaged public var cloudiness: Int16
    @NSManaged public var forecast: ForecastEntity?

}
