//
//  Date+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

private struct StaticVariables {
    
    private static var formatter: DateFormatter = DateFormatter()
    private static let dateFormat = "yyyy-MM-dd"
    private static let dateTimeFormat = "yyyy-MM-dd'T'H:mm"
    private static let timeFormat = "H:mm"
    private static let twelveHourFormat = "h:mm a"
    private static let utcTimeZone = "UTC"

    
    static let dayInSeconds: TimeInterval = 60 * 60 * 24
    
    static func utcDateFormatter() -> DateFormatter {
        formatter.dateFormat = dateFormat
        formatter.locale = NSLocale.current
        formatter.timeZone = NSTimeZone(abbreviation: utcTimeZone) as TimeZone?
        return formatter
    }
    
    static func dateTimeFormatter() -> DateFormatter {
        formatter.dateFormat = dateTimeFormat
        formatter.locale = NSLocale.current
        formatter.timeZone = NSTimeZone(abbreviation: utcTimeZone) as TimeZone?
        return formatter
    }
    
    static func timeFormatter() -> DateFormatter {
        formatter.dateFormat = timeFormat
        formatter.locale = NSLocale.current
        return formatter
    }
    
    static func twelveHourFormatter() -> DateFormatter {
        formatter.dateFormat = twelveHourFormat
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
    
    func dateTimeFormat() -> String {
        return StaticVariables.dateTimeFormatter().string(from: self)
    }
    
    func twelweHourFormat() -> String {
        return StaticVariables.twelveHourFormatter().string(from: self)
    }
    
    static func date(from dateString: String?, timeFormat: String) -> Date? {
        StaticVariables.dateTimeFormatter().dateFormat = timeFormat
        if let string = dateString {
            let day = StaticVariables.dateTimeFormatter().date(from: string)
            return day
        }
        return nil
    }
}
