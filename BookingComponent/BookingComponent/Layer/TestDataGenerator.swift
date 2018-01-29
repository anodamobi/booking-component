//
//  TestDataGenerator.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

class TestDataGenerator {
    
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60 * 60
    static let stringDate = Date().dateFormat()
    
    static func createVendor() -> VendorModel {
        
        let vendor = VendorModel()
        vendor.startTime = Date.date(from: stringDate + "T8:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        vendor.endTime = Date.date(from: stringDate + "T18:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        vendor.contactData.city = "New York"
        vendor.contactData.country = "U.S."
        vendor.contactData.details = "Dummy text :^)"
        vendor.procedures = [.haircut, .manicure]
        vendor.timeZone = NSTimeZone.local
        vendor.photoURL = ""
        vendor.serviceProviders = createServiceProviders()
        vendor.bookingSettings.timeGap = 5 * minute
        
        return vendor
    }
    
    static func createServiceProviders() -> [ServiceProvider] {
        
        let haircut = ServiceProvider()
        let booking1 = BookingModel()
        let booking2 = BookingModel()
        
        haircut.bookingSettings.timeGap = 5 * minute
        haircut.startTime = Date.date(from: stringDate + "T10:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        haircut.endTime = Date.date(from: stringDate + "T20:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        haircut.firstName = "Felitia"
        haircut.lastName = "Boldsome"
        
        let procedure = Procedure(procedureName: "Hair style", details: "Test", durationPrice: 80, procedureDuration: 30 * minute)
        haircut.availableProcedureTypes = [.haircut: procedure]
        haircut.bookingSettings.timeGap = 10 * minute
        
        booking1.client = createClinet(id: 177)
        booking1.procedure.startDate = Date.date(from: stringDate + "T11:00", timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
        booking1.procedure.endDate = booking1.procedure.startDate.addingTimeInterval(procedure.procedureDuration + haircut.bookingSettings.timeGap)
        booking1.eventDate = Date.date(from: stringDate, timeFormat: "yyyy-MM-dd") ?? Date()
        
        booking2.client = createClinet(id: 32)
        booking2.procedure.startDate = Date.date(from: stringDate + "T10:00", timeFormat: "yyyy-MM-dd'T'H:mm")?.addingTimeInterval(24 * hour) ?? Date().addingTimeInterval(24 * hour)
        booking2.procedure.endDate = booking2.procedure.startDate.addingTimeInterval(procedure.procedureDuration + haircut.bookingSettings.timeGap)
        booking2.eventDate = (Date.date(from: stringDate, timeFormat: "yyyy-MM-dd")?.addingTimeInterval(24 * hour)) ?? Date().addingTimeInterval(24 * hour)
        
        haircut.bookings = [booking1, booking2]
        
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
