//
//  Date+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

private struct StaticVariables {
    
    private static var formatter: DateFormatter = DateFormatter()
    //private static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    private static let dateFormat = "yyyy-MM-dd"
    private static let timeFormat = "HH:mm"
    private static let utcTimeZone = "UTC"
//    private static let cstTimeZone = "CST"
//    private static let gmtTimeZone = "GMT"
    
    static let dayInSeconds: TimeInterval = 60 * 60 * 24
    
    static func utcDateFormatter() -> DateFormatter {
        formatter.dateFormat = dateFormat
        formatter.locale = NSLocale.current
        formatter.timeZone = NSTimeZone(abbreviation: utcTimeZone) as TimeZone?
        return formatter
    }
    
    static func timeFormatter() -> DateFormatter {
        formatter.dateFormat = timeFormat
        formatter.locale = NSLocale.current
        return formatter
    }
}

extension Date {
    
    func hourMinuteFormat() -> String {
        return StaticVariables.timeFormatter().string(from: self)
    }
    
    func dateFormat() -> String {
        return StaticVariables.utcDateFormatter().string(from: self)
    }
}
