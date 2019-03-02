//
//  CitiesFileViewModel.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class CitiesFileViewModel {
    
    private var _cityFileViewModels: [CityFileViewModel] = []
    private var _filteredCityFileViewModels: [CityFileViewModel] = []
    var didUpdate: (()->())? = nil
    var didFail: ((WeatherError?)->())? = nil
    
    var filterString: String = "" {
        didSet {
            filterContent(for: filterString)
        }
    }
    
    var count: Int {
        return _filteredCityFileViewModels.count
    }
    
    /** Fetch cities from  file in background */
    func fetchCitiesFromFile() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            Cities.sharedInstance.loadCitiesIfRequired({ [weak self] (cities) in
                print("all cities loaded")
                guard let weakSelf = self else {
                    return
                }
                let fileViewModels = cities.map{CityFileViewModel(with: $0)}
                weakSelf._cityFileViewModels = fileViewModels
                weakSelf._filteredCityFileViewModels = fileViewModels
                weakSelf.didUpdate?()
            })
        }
    }
    
    /** Search of a city by name */
    func filterContent(for searchText: String) {
        // Update the searchResults array with matches
        // in our entries based on the title value.
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            
            if searchText.isEmpty {
                weakSelf._filteredCityFileViewModels = weakSelf._cityFileViewModels
                weakSelf.didUpdate?()
                return
            }
            weakSelf._filteredCityFileViewModels = Cities.sharedInstance.all().filter({ (cityFileModel) -> Bool in
                let matchName = cityFileModel.name.range(of: searchText, options: .caseInsensitive)
                let matchCountry = cityFileModel.country.range(of: searchText, options: .caseInsensitive)
                if matchName != nil || matchCountry != nil {
                    return true
                }
                return false
            }).map{ CityFileViewModel(with: $0) }
            weakSelf.didUpdate?()
        }
    }
    
    
    /** fetch the CityFileViewModel at a given index */
    func viewModel(at index: Int)-> CityFileViewModel? {
        if count > 0 && index >= 0 && index < count {
            return _filteredCityFileViewModels[index]
        }
        return nil
    }
    
}
