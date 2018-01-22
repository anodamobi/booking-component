//
//  DataStructHelper.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation



struct BusinessTime {
    var startDate: Date = Date()
    var endDate: Date = Date()
}

class Booking {
    
    var client: CustomerModel = CustomerModel()
    var when: Date = Date()
    var procedure: ProcedureDuration = ProcedureDuration()
}

struct ProcedureDuration {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func procedureLength() -> TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}
