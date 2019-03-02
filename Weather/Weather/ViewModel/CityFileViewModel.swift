//
//  CityFileViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class CityFileViewModel {
    private var _cityFileModel: CityFileModel
    private let dataProvider = DataProvider()
    
    /** Init with CityFileModel */
    init(with model: CityFileModel) {
        _cityFileModel = model
    }
    
    /** Gets the name for City appended with country name */
    var name: String {
        return _cityFileModel.name + ", " + _cityFileModel.country
    }
    
    
    /** Saves the city to database */
    func save() {
        let cityDataModel = CityDataModel.init(id: _cityFileModel.id, name: _cityFileModel.name, country: _cityFileModel.country, latitude: _cityFileModel.coordinate.latitude, longitude: _cityFileModel.coordinate.longitude, forecasts: nil, lastUpdateTimestamp: 0)
        dataProvider.save(city: cityDataModel)
    }
    
}
