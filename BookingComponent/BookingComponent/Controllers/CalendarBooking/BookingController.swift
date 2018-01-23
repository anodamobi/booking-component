//
//  BookingController.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

class BookingController: NSObject {
    
    var booked: [Booking] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    var timeBeforeSession: TimeInterval = 60 * 60 // 1h by default.

    func update(booked: [Booking], startDate: Date, endDate: Date) {
        self.endDate = endDate
        self.startDate = startDate
        self.booked = booked
    }
    
    func isPossibleToBook(newBook: Booking) -> [Date: TimeInterval] { //TODO: add start Date to return
        
        let procedureLength = newBook.procedure.procedureLength()
        var validTimeIntervals: [Date: TimeInterval] = [:]
        var topTimeLimit = startDate
        var availableBookings = booked
        
        //NOTE: Not in past (yesterday).
        guard newBook.procedure.startDate.timeIntervalSince(startDate) > 0 else {
            return [:]
        }
        
        if isTimePast(start: newBook.procedure.startDate) {
            topTimeLimit = Date().addingTimeInterval(timeBeforeSession)
        }
        
        guard booked.count > 0 else {
            return [endDate:endDate.timeIntervalSince(startDate)]
        }
        
        if !isTimeBeforeSession(start: newBook.procedure.startDate) {
            availableBookings = findPossibleTime(availableBookings, newBook)
            topTimeLimit = Date().addingTimeInterval(timeBeforeSession)
        }
        
        guard availableBookings.count > 0 else {
            return [:]
        }
        
        for index in 0..<availableBookings.count {
            
            if index == 0 {
                
                let timeInterval =  availableBookings[index].procedure.startDate.timeIntervalSince(topTimeLimit)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals = [topTimeLimit: timeInterval]
                }
            } else if index == (availableBookings.count - 1) {
                
                let timeInterval = endDate.timeIntervalSince(availableBookings[index].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals = [availableBookings[index].procedure.endDate: timeInterval]
                }
            } else {
                
                let timeInterval = availableBookings[index].procedure.startDate.timeIntervalSince(availableBookings[index - 1].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals = [availableBookings[index - 1].procedure.endDate: timeInterval]
                }
            }
        }
        
        return validTimeIntervals
    }
    
    func possibleChunks() -> [Date: TimeInterval] {
        
        var availableTime: [Date: TimeInterval] = [:]
        
        for index in 0..<booked.count {
            
            if index == 0 {
                
                let interval = booked[index].procedure.startDate.timeIntervalSince(startDate)
                if interval >= booked[index].procedure.procedureLength() {
                    availableTime[startDate] = interval
                }
            } else if index == (booked.count - 1) {
                
                let interval = endDate.timeIntervalSince(booked[index].procedure.endDate)
                if interval >= booked[index].procedure.procedureLength() {
                    availableTime[booked[index].procedure.endDate] = interval
                }
            } else {
                let interval = booked[index].procedure.startDate.timeIntervalSince(booked[index - 1].procedure.endDate)
                if interval >= booked[index].procedure.procedureLength() {
                    availableTime[booked[index - 1].procedure.endDate] = interval
                }
            }
        }
        return availableTime
    }
    
    
//    MARK: Helpers
    
    private func isTimePast(start: Date) -> Bool {
        return start.timeIntervalSince(Date()) < 0
    }
    
    private func isTimeBeforeSession(start: Date) -> Bool {
        return start.timeIntervalSince(Date()) > self.timeBeforeSession
    }
    
    private func compareTimeIntervals(_ frombooked: TimeInterval, procedure: TimeInterval) -> Bool {
        return frombooked >= procedure
    }
    
    private func findPossibleTime(_ bookings: [Booking], _ newBook: Booking) -> [Booking] {
        var result: [Booking] = []
        
        for book in bookings {
            if !isTimePast(start: book.procedure.startDate) {
                result += [book]
            }
        }
        
        var filteredDates: [Booking] = []
        for index in 0..<result.count {
            let newBookDate = newBook.procedure.startDate.dateFormat()
            let current = result[index].procedure.startDate.dateFormat()
            let comparisonResult = Date.date(from: newBookDate,
                                             timeFormat: "yyyy-MM-dd")?
                .compare(Date.date(from: current,
                                   timeFormat: "yyyy-MM-dd") ?? Date())
            if comparisonResult == .orderedSame {
                filteredDates += [result[index]]
            }
        }
        
        return filteredDates
    }
    
}

