//
//  BookingController.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

class BookingController: NSObject {
    
    var booked: [Booking] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    init(booked: [Booking], startDate: Date, endDate: Date) {
        super.init()
        self.endDate = endDate
        self.startDate = startDate
        self.booked = booked
    }
    
    func isPossibleToBook(procedureLength: TimeInterval) -> Bool {
        
        var canBeBooked = false
        
        guard booked.count > 0 else {
            return true //we can book
        }
        
        for index in 0..<booked.count {
            if index == 0 {
                
                let timeInterval =  booked[index].when.timeIntervalSince(startDate)
                canBeBooked = compareTimeIntervals(timeInterval, procedure: procedureLength)
            } else if index == (booked.count - 1) {
                
                let timeInterval = endDate.timeIntervalSince(booked[index].when)
                canBeBooked = compareTimeIntervals(timeInterval, procedure: procedureLength)
            } else {
                
                let timeInterval = booked[index].when.timeIntervalSince(booked[index - 1].when)
                canBeBooked = compareTimeIntervals(timeInterval, procedure: procedureLength)
            }
        }
        
        return canBeBooked
    }
    
    private func compareTimeIntervals(_ frombooked: TimeInterval, procedure: TimeInterval) -> Bool {
        return frombooked >= procedure ? true : false
    }
    
}


class Booking {
    
    var client: CustomerModel = CustomerModel()
    var when: Date = Date()
    var procedrue: Procedure = Procedure()
    
}

struct Procedure {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func procedureLength() -> TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}
