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
    var selectedDate: Date?
    var timeBeforeSession: TimeInterval = 60 * 60 // 1h by default.

    func update(booked: [Booking], startDate: Date, endDate: Date, selectedDate: Date? = nil) {
        self.endDate = endDate
        self.startDate = startDate
        self.booked = booked
        self.selectedDate = selectedDate
    }
    
    func isPossibleToBook(newBook: Booking) -> Bool {
        
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
        
        var dateChunks: [Booking] = []
        
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
    
    
//    MARK: Helpers
    
    private func isTimePast(start: Date) -> Bool {
        return start.compare(Date()) == ComparisonResult.orderedAscending
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
    
    private func isInTimeLimits(date: Date, procedureLength: TimeInterval) -> Bool {
        
        let dateFinish = date.addingTimeInterval(procedureLength)
        let topMinutes: Float = date.component(.minute) > 0 ? Float(1 / date.component(.minute)) : 0.1
        let selectedTimeTop: Float = Float(date.component(.hour)) + topMinutes
        
        let botMinutes: Float = dateFinish.component(.minute) > 0 ? Float(1 / dateFinish.component(.minute)) : 0.1
        let selectedTimeBot: Float = Float(dateFinish.component(.hour)) + botMinutes
        
        let startMinutes: Float = startDate.component(.minute) > 0 ? Float(1 / startDate.component(.minute)) : 0.1
        let startDateNorm: Float = Float(startDate.component(.hour)) + startMinutes
        
        let endMinutes: Float = endDate.component(.minute) > 0 ? Float(1 / endDate.component(.minute)) : 0.1
        let endDateNorm: Float = Float(endDate.component(.hour)) + endMinutes
        
        return startDateNorm < selectedTimeTop && endDateNorm > selectedTimeBot
    }
    
    private func isBookingPossible(bookings: [Booking], date: Date) -> Bool {
        var isTimeFree = true
        if bookings.count > 0 {
            
            for item in bookings {
                
                if !(item.procedure.startDate.compare(date) == .orderedSame) {
                    
                    if !(item.procedure.endDate.compare(date) == .orderedSame) {
                        continue
                    } else {
                        isTimeFree = false
                    }
                    
                } else {
                    isTimeFree = false
                }
            }
        }
        return isTimeFree
    }
    
    private func calculateTimeChunks(dateChunks: [Booking], start: Date, end: Date) -> [Date: TimeInterval] {
        
        var availableTime: [Date: TimeInterval] = [:]
        
        for index in 0..<dateChunks.count {
            
            if index == 0 {
                
                let interval = dateChunks[index].procedure.startDate.timeIntervalSince(start)
                if interval >= dateChunks[index].procedure.duration() {
                    availableTime[start] = interval
                }
            }
            if index == (dateChunks.count - 1) {
                
                var interval = dateChunks[index].procedure.endDate.timeIntervalSince(end)
                if interval < 0 {
                    interval *= -1
                }
                if interval >= dateChunks[index].procedure.duration() {
                    availableTime[dateChunks[index].procedure.endDate] = interval
                }
            } else {
                
                let interval = dateChunks[index].procedure.startDate.timeIntervalSince(dateChunks[index - 1].procedure.endDate)
                if interval >= dateChunks[index].procedure.duration() {
                    availableTime[dateChunks[index - 1].procedure.endDate] = interval
                }
            }
        }
        return availableTime
    }
}

