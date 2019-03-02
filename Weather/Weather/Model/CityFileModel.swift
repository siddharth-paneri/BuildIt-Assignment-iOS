//
//  CityFileModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

struct Coordinate {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Coordinate: Decodable {
    enum CoordinateKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoordinateKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        
        self.init(latitude: latitude, longitude: longitude)
    }
}

struct CityFileModel {
    var id: Int64
    var name: String
    var country: String
    var coordinate: Coordinate
    
    
    init(id: Int64, name: String, country: String, coordinate: Coordinate) {
        self.id = id
        self.name = name
        self.country = country
        self.coordinate = coordinate
    }
}


extension CityFileModel: Decodable {
    enum CityKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case country = "country"
        case coordinate = "coord"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CityKeys.self)
        let id: Int64 = try container.decode(Int64.self, forKey: .id)
        let name: String = try container.decode(String.self, forKey: .name)
        let country: String = try container.decode(String.self, forKey: .country)
        let coordinate: Coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        self.init(id: id, name: name, country: country, coordinate: coordinate)
        
    }
}
