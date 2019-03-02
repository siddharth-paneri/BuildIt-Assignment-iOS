//
//  CityViewModelsTests.swift
//  WeatherTests
//
//  Created by Siddharth Paneri on 02/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest
@testable import Weather

class CityViewModelsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func getCityDataModelInput() -> [CityDataModel] {
        return [
            CityDataModel(id: 1, name: "City 1", country: "Country 1", latitude: 12.0, longitude: 17.0, forecasts: nil, lastUpdateTimestamp: 0),
            CityDataModel(id: 2, name: "", country: "", latitude: 0, longitude: 11111111111111111111111111.11111111, forecasts: nil, lastUpdateTimestamp: 0),
            CityDataModel(id: 3, name: "City 2", country: "", latitude: 12.0, longitude: 17.0, forecasts: nil, lastUpdateTimestamp: 0),
            CityDataModel(id: 4, name: "City 4 with a large city name and special characters like,./';?><:[]{}=-+_)(*&^%$#@!~`", country: "Country 4", latitude: 12.0, longitude: 17.0, forecasts: nil, lastUpdateTimestamp: 0)
        ]
    }
    
    func testCityViewModel() {
    
        var cityDataModels = getCityDataModelInput()
        
        let cityViewModels = cityDataModels.map{ CityViewModel(with: $0)}
        
        for i in 0..<cityViewModels.count {
            let cityVM = cityViewModels[i]
            let cityDM = cityDataModels[i]
            XCTAssert(cityVM.id == cityDM.id, "Id mismatch")
            XCTAssert(cityVM.lastFetch == cityDM.lastUpdateTimestamp, "LUT mismatch")
            XCTAssert(cityVM.name == "\(cityDM.name), \(cityDM.country)", "city name, country mismatch")
            
        }
        
    }

}
