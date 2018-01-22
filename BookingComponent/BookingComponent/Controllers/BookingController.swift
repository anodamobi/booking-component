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
    var timeBeforeSession: TimeInterval = 60 * 60 // 1h by default.
    
    func update(booked: [Booking], startDate: Date, endDate: Date) {
        self.endDate = endDate
        self.startDate = startDate
        self.booked = booked
    }
    
    func isPossibleToBook(newBook: Booking) -> [TimeInterval] { //TODO: add start Date to return
        
        let procedureLength = newBook.procedure.procedureLength()
        var validTimeIntervals: [TimeInterval] = []
        var topTimeLimit = startDate
        var availableBookings = booked
        
        guard newBook.procedure.startDate.timeIntervalSince(startDate) > 0 else {
            return []
        }
        
        guard booked.count > 0 else {
            return [endDate.timeIntervalSince(startDate)]
        }
        
        if isTimePast(start: newBook.procedure.startDate) {
            topTimeLimit = Date().addingTimeInterval(timeBeforeSession)
        }
        
        if !isTimeBeforeSession(start: newBook.procedure.startDate) {
            availableBookings = findPossibleTime(availableBookings)
            topTimeLimit = Date().addingTimeInterval(timeBeforeSession)
        }
        
        guard availableBookings.count > 0 else {
            return []
        }
        
        for index in 0..<availableBookings.count {
            if index == 0 {
                
                let timeInterval =  availableBookings[index].procedure.startDate.timeIntervalSince(topTimeLimit)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            } else if index == (availableBookings.count - 1) {
                
                let timeInterval = endDate.timeIntervalSince(availableBookings[index].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            } else {
                
                let timeInterval = availableBookings[index].procedure.startDate.timeIntervalSince(availableBookings[index - 1].procedure.endDate)
                if compareTimeIntervals(timeInterval, procedure: procedureLength) {
                    validTimeIntervals += [timeInterval]
                }
            }
        }
        
        return validTimeIntervals
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
    
    private func findPossibleTime(_ bookings: [Booking]) -> [Booking] {
        var result: [Booking] = []
        
        for book in bookings {
            if !isTimePast(start: book.procedure.startDate) {
                result += [book]
            }
        }
        return result
    }
    
}

