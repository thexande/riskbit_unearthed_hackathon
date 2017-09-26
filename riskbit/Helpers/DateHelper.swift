//
//  DateHelper.swift
//  thexande_firebase_white_label
//
//  Created by Alex Murphy on 6/16/17.
//  Copyright © 2017 thexande. All rights reserved.
//

import Foundation

class DateHelper {
    static func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        return dateFormatter.date(from: dateString)!
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        return dateFormatter.string(from: date as Date)
    }
    
    static func currentTimeStampString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        return dateFormatter.string(from: date as Date)
    }
    
    static func readableDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    static func currentUnixTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970 * Double(-1000))
    }
    
    static func readableDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy"
        return formatter.string(from: date)
    }
}
