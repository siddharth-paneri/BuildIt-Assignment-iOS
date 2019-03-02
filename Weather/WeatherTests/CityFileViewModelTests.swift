//
//  CityFileViewModelTests.swift
//  WeatherTests
//
//  Created by Siddharth Paneri on 02/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest
@testable import Weather

class CityFileViewModelTests: XCTestCase {

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
    
    
    class func getCityFileModels(from file: String) -> [CityFileModel] {
        if let bundle = Bundle(identifier: "com.siddharth.WeatherTests") {
            if let jsonData = JSONReader.read(file: file, bundle: bundle) {
                do {
                    let cities = try JSONDecoder().decode([CityFileModel].self, from: jsonData)
                    return cities
                } catch {
                    XCTFail("Decoding error")
                    return []
                }
            } else {
                XCTFail("Empty file")
                return []
            }
        } else {
            XCTFail("Test bundle not found")
        }
        return []
    }
    
    func testDecoding() {
        _ = CityFileViewModelTests.getCityFileModels(from: "CitiesTest_1")
        _ = CityFileViewModelTests.getCityFileModels(from: "CitiesTest_2")
    }
    
    
    // this test should be run fresh so there is no data in database
    func testCityFileViewModel() {
        let filemodels = CityFileViewModelTests.getCityFileModels(from: "CitiesTest_1")
        print("total file models = \(filemodels.count)")
        let cityFileViewModels = filemodels.map{CityFileViewModel(with: $0)}
        print(cityFileViewModels)
        for cityFileVM in cityFileViewModels {
            cityFileVM.save()
        }

        let citiesViewModel = CitiesViewModel()
        citiesViewModel.didUpdate = {
            print("Total view models = \(citiesViewModel.count)")
            XCTAssert(citiesViewModel.count == filemodels.count, "Number of cities is not same")
        }

        citiesViewModel.didFail = { (weatherError) in
            XCTFail("View model update failed")
        }

        citiesViewModel.fetchCities()
        
    }
}
