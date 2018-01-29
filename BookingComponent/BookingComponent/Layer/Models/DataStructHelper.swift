//
//  DataStructHelper.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

struct BusinessTime {
    var startDate: Date = Date()
    var endDate: Date = Date()
}

class BookingModel {
    
    var client: ClientModel = ClientModel()
    var eventDate: Date = Date()
    var procedure: ProcedureDuration = ProcedureDuration()
}

struct ProcedureDuration {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func duration() -> TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}

struct Procedure {
    
    var procedureName: String = ""
    var details: String = ""
    var durationPrice: Float = 0
    var procedureDuration: TimeInterval = 0
}

class BookViewModel {
    var vendor: VendorModel = VendorModel()
    var procedureType: ProcedureType = .none
    var client: ClientModel = ClientModel()
    var selectedDate: Date = Date()
    var serviceProviderIndex: ServiceProviderType = .haircut
}
