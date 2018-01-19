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
    var phoneNumber: String = ""
    var email: String = ""

    var timeZone: TimeZone = TimeZone.current

    var timeStep: Int = 5 //minimal step to increase sessionLength
}
