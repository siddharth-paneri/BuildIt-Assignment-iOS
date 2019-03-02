//
//  JSONReader.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// Class can be used to read json files and decode it later as required

import Foundation


class JSONReader {
    
    // method used to read a specific file name from main bundle
    class func read(file fileName: String) -> Data? {
        return JSONReader.read(file: fileName, bundle: Bundle.main)
    }
    
    // method used to read a specific file from specified bundle
    class func read(file fileName: String, bundle: Bundle) -> Data? {
        if let mainBundle = bundle.path(forResource: fileName, ofType: "json") {
            if(FileManager.default.fileExists(atPath: mainBundle)) {
                if let jsonData = FileManager.default.contents(atPath: mainBundle) {
                    return jsonData
                } else {
                    print("File contents = nil")
                }
            } else {
                print("File does not exist")
            }
        } else {
            print("File not found in bundle")
        }
        return nil
    }
    
}
