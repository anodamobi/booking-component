//
//  VendorModel.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class VendorModel: NSObject {
    
    var startTime: Date = Date() // HH:MM
    var endTime: Date = Date() //HH:MM
    var timeTable: [Date: [Int:CustomerModel]] = [:] // [ID: Customer]
    var rate: Float = 0.0 //price per timeUnit
    var unit: UnitType = .minute
    var pricePerCustomer: Float = 0.0 //static price per customer
    var timeGap: TimeInterval = 15 * 60 // base value of 15 minutes
    var serviceType: ServiceType = .none
    var timeZone: TimeZone = TimeZone.current
    var country: String = ""
    var state: String = ""
    var city: String = ""
    var details: String = ""
    var publicHolidays: [Date] = []
    var profileDetails: String = ""
    var phone: String = ""
    var email: String = ""
    var profilePhotoURL: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var currentCustomer: CustomerModel = CustomerModel() // set from timeTable

    
}
