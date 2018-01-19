//
//  CustomerModel.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class CustomerModel: NSObject {
    
    var userID: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var reservedDate: Date = Date() //yyyy-MM-dd
//    var reservedTime: Date = Date() //HH:mm
    var bookedPrice: Float = 0.0
    var untis: UnitType = .minute
    var vendor: VendorModel = VendorModel()
    var timeZone: TimeZone = TimeZone.current
    var wishedSessionTime: Date = Date() //HH:mm
    var sessionLength: Int = 0 // reservtion length depends on it.
    var timeStep: Int = 5 //minimal step to increase sessionLength
    var reservationLength: TimeInterval = TimeInterval(exactly: 0)!
    var profilePhotoURL: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    
    
    func pricePerUnit(unit: UnitType) -> String {
        return ""
    }
    
    func dateAndTime() -> String {
        return reservedDate.dateTimeFormat()
    }
    
    func fullDateTime() {
        
    }
    
}
