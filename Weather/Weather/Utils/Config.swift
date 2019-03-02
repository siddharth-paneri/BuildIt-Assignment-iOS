//
//  Config.swift
//  Weather
//
//  Created by Siddharth Paneri on 01/03/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
// This helper class can be used to format date and time values to string, it does not create multiple instances of date formatter so processing speed when formatting date to string is not affected.

import Foundation


class Config {
    
    private static var _shared: Config?
    class var shared: Config {
        guard let sh = _shared else {
            _shared = Config()
            return _shared!
        }
        return sh
    }
    
    // date formatter for time string
    private var dateFormatter_Time: DateFormatter? = nil
    func getTimeString(timeInterval: TimeInterval) -> String {
        if dateFormatter_Time == nil {
            dateFormatter_Time = DateFormatter()
            dateFormatter_Time?.dateFormat = "hh:mm a"
        }
        guard let df = dateFormatter_Time else {
            return ""
        }
        return df.string(from: Date(timeIntervalSince1970: timeInterval))
    }
    
    // date formatter for date string
    private var dateFormatter_Date: DateFormatter? = nil
    func getDateString(timeInterval: TimeInterval) -> String {
        if dateFormatter_Date == nil {
            dateFormatter_Date = DateFormatter()
            dateFormatter_Date?.dateFormat = "dd-MM-yyyy"
        }
        guard let df = dateFormatter_Date else {
            return ""
        }
        return df.string(from: Date(timeIntervalSince1970: timeInterval))
    }
    
}
