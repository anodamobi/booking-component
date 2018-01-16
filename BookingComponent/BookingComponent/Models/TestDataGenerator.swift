//
//  TestDataGenerator.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class TestDataGenerator: NSObject {
    
    static func arrayOfCustomers() -> [CustomerModel] {
        
        return []
    }
    
    static func singleUser() -> CustomerModel {
        
        let user = CustomerModel()
        
        user.firstName = "User 1"
        user.lastName = "Test 1"
        user.email = "user1Test@anoda.io"
        user.phoneNumber = "+48(044) 882-39-45"
        user.profilePhotoURL = ""
        user.sessionLength = 2
        user.reservationLength = TimeInterval(60 * 60 * user.sessionLength)  // 2h
        user.reservationPeriod.startDate = Date()
        user.reservationPeriod.endDate = Date().addingTimeInterval(user.reservationLength)
        user.reservedTime = Date(timeIntervalSinceReferenceDate: 1200)
        user.untis = .hour
        user.bookedPrice = 40
        user.timeStep = 10
        user.timeZone = TimeZone.current
        user.wishedSessionTime = Date(timeIntervalSinceReferenceDate: 1200)
        
        return user
    }
    
    static func singleVendor() -> VendorModel {
        
        return VendorModel()
    }
    
    static func arrayOfVendors() -> [VendorModel] {
        
        return []
    }
    
}
