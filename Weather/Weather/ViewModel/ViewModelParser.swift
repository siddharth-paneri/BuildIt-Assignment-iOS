//
//  ViewModelParser.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class ViewModelParser {
    
    /** PArse city data model to city view model */
    class func parse(cityDataModel: CityDataModel) -> CityViewModel {
        return CityViewModel(with: cityDataModel)
    }
    
    /** Parse [CityDataModel] to [CityViewModel] */
    class func parse(cityDataModels: [CityDataModel]) -> [CityViewModel] {
        var cityViewModels: [CityViewModel] = []
        for model in cityDataModels {
            cityViewModels.append(CityViewModel(with: model))
        }
        return cityViewModels
    }
}
