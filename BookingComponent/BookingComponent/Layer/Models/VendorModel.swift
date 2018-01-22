//
//  VendorModel.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class VendorModel: NSObject {
    
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    var procedures: [ProcedureType] = []
    var timeZone: TimeZone?
    var dayOff: Date?
    var photoURL: String = ""
    
    var contactData: ContactData = ContactData()
    var bookingSettings: VendorBookingSettings = VendorBookingSettings()
    var serviceProviders: [ServiceProvider] = []
}

class VendorBookingSettings {
    
    var timeGap: TimeInterval = 0
}

class ContactData {
    
    var country: String = ""
    var state: String = ""
    var city: String = ""
    var website: String = ""
    var details: String = ""
    var phone: String = ""
    var email: String = ""
}

class ServiceProvider {
    
    var availableProcedureTypes: [ProcedureType: Procedure] = [:]
    
    var firstName: String = ""
    var lastName: String = ""
    var bookings: [Booking] = []
    
    var startTime: Date = Date()
    var endTime: Date = Date()
    var bookingSettings: VendorBookingSettings = VendorBookingSettings()
    
    
}

