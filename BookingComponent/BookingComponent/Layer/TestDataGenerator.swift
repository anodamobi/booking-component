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
    static let stringDate = Date().dateFormat()
    
    static func createVendor() -> VendorModel {
        
        let vendor = VendorModel()
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
        
        return vendor
    }
    
    static func createServiceProviders() -> [ServiceProvider] {
        
        let haircut = ServiceProvider(types: [.haircut])
        let booking1 = Booking()
        booking1.client = createClinet(id: 177)
        booking1.procedure.startDate = Date.date(from: stringDate + "T11:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        booking1.procedure.endDate = Date.date(from: stringDate + "T12:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        booking1.when = Date.date(from: stringDate, timeFormat: "yyyy-MM-dd") ?? Date()
        haircut.bookings = [booking1]
        haircut.bookingSettings.timeGap = 5 * minunte
        haircut.startTime = Date.date(from: stringDate + "T10:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        haircut.endTime = Date.date(from: stringDate + "T20:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        haircut.firstName = "Felitia"
        haircut.lastName = "Boldsome"
        
        return [haircut]
    }
    
    static func createClinet(id: Int) -> ClientModel {
        let client = ClientModel()
        client.userID = id
        client.phoneNumber = "+18-048-85-99-344"
        client.firstName = "Grzegorzh \(id)"
        client.lastName = "Brzyczyprzcykevic"
        return client
    }
}
