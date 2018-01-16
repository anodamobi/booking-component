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
    
    func isPossibleToBook(newBook: Booking) -> [TimeInterval] {
        
        let procedureLength = newBook.procedure.endDate.timeIntervalSince(newBook.procedure.startDate)
        var validTimeIntervals: [TimeInterval] = []
        
        guard booked.count > 0 else {
            return [endDate.timeIntervalSince(startDate)]
        }
        
        for index in 0..<booked.count {
            if index == 0 {
                
                let timeInterval =  booked[index].procedure.startDate.timeIntervalSince(startDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            } else if index == (booked.count - 1) {
                
                let timeInterval = endDate.timeIntervalSince(booked[index].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            } else {
                
                let timeInterval = booked[index].procedure.startDate.timeIntervalSince(booked[index - 1].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            }
        }
        
        return validTimeIntervals
    }
    
    private func compareTimeIntervals(_ frombooked: TimeInterval, procedure: TimeInterval) -> Bool {
        return frombooked >= procedure ? true : false
    }
    
}


class Booking {
    
    var client: CustomerModel = CustomerModel()
    var when: Date = Date()
    var procedure: Procedure = Procedure()
    
}

struct Procedure {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func procedureLength() -> TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}
