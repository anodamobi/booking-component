//
//  BookingController.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

class BookingController: NSObject {
    
    var booked: [BookingModel] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    var selectedDate: Date?
    var timeBeforeSession: TimeInterval = 60 * 60 // 1h by default.

    func update(booked: [BookingModel], startDate: Date, endDate: Date, selectedDate: Date? = nil) {
        self.endDate = endDate
        self.startDate = startDate
        self.booked = booked
        self.selectedDate = selectedDate
    }
    
    func isPossibleToBook(newBook: BookingModel) -> Bool {
        
        let procedureLength = newBook.procedure.duration()
        var couldBeBooked = false
        var topTimeLimit = startDate
        let availableBookings = booked
        
        guard newBook.procedure.startDate.timeIntervalSince(startDate) > 0 else {
            return false
        }
        
        if isTimePast(start: newBook.procedure.startDate) {
            topTimeLimit = Date().addingTimeInterval(timeBeforeSession)
        }
        
        if let date = selectedDate {
            
            let resultInRange = topTimeLimit.compare(date)
            guard resultInRange != .orderedDescending else {
                return false
            }
                
            let resultReservation = date.addingTimeInterval(-timeBeforeSession).compare(topTimeLimit)
            guard resultReservation != .orderedAscending else {
                return false
            }
            
            guard isInTimeLimits(date: date, procedureLength: procedureLength) else {
                return false
            }
            
            if isBookingPossible(bookings: availableBookings, date: date) {
                couldBeBooked = true
            }
        }

        return couldBeBooked
    }
    
    func possibleChunks(for date: Date) -> [Date: TimeInterval] {
        
        let startString = date.dateFormat() + "T" + startDate.hourMinuteFormat()
        let endString = date.dateFormat() + "T" + endDate.hourMinuteFormat()
        let start = Date.date(from: startString, timeFormat: "yyyy-mm-dd'T'H:mm") ?? startDate
        let end = Date.date(from: endString, timeFormat: "yyyy-mm-dd'T'H:mm") ?? endDate
        
        guard booked.count > 0 else {
            return [startDate: endDate.timeIntervalSince(startDate)];
        }
        
        var dateChunks: [BookingModel] = []
        
        for element in booked {
            
            if element.procedure.startDate.dateFormat() == date.dateFormat() {
                dateChunks += [element]
            }
        }
        guard !dateChunks.isEmpty else {
            
            let interval = endDate.timeIntervalSince(startDate)
            return [start: interval]
        }
        
        return calculateTimeChunks(dateChunks: dateChunks, start: start, end: end)
    }
}

