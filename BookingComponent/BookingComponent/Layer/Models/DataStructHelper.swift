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
    
    var client: ClientModel = ClientModel()
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

struct Procedure {
    
    var procedureName: String = ""
    var details: String = ""
    var durationPrice: Float = 0
    var procedureDuration: TimeInterval = 0
}
