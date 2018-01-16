//
//  DataStructHelper.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

enum ServiceType: String, Equatable {
    case service1 = "service1"
}

enum UnitType: String, Equatable {
    case minute = "minute"
    case hour = "hour"
    case day = "day"
    case week = "week"
    case month = "month"
}

struct ReservationPeriod {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func reservationLenght(unit: UnitType) -> Float {
        var interval: TimeInterval = endDate.timeIntervalSince(startDate)
        
        //TODO: pavel convert to specific lengh depend on unit. Include timezone.
        return Float(interval)
    }
}
