//
//  TestDataGenerator.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class TestDataGenerator {
    
    static let minunte: TimeInterval = 60
    static let hour: TimeInterval = 60 * 60
    
    static func createVendor() -> VendorModel {
        
        let vendor = VendorModel()
        let stringDate = Date().dateFormat()
        vendor.startTime = Date.date(from: stringDate + "T10:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        vendor.endTime = Date.date(from: stringDate + "T20:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        vendor.contactData.city = "New York"
        vendor.contactData.country = "U.S."
        vendor.contactData.details = "Dummy text :^)"
        vendor.procedures = [.haircut, .manicure]
        vendor.timeZone = NSTimeZone.local
        vendor.photoURL = ""
        vendor.serviceProviders = createServiceProviders()
        vendor.bookingSettings.timeGap = 5 * minunte
        
        return VendorModel()
    }
    
    static func createServiceProviders() -> [ServiceProvider] {
        
        let haircut = ServiceProvider(types: [.haircut])
        let booking1 = Booking()
        booking1.client = ClientModel()
        haircut.bookings = [booking1]
        
        return []
    }
}
