//
//  BookingController+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/29/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

extension BookingController {
    
    func isTimePast(start: Date) -> Bool {
        return start.compare(Date()) == ComparisonResult.orderedAscending
    }
    
    func isTimeBeforeSession(start: Date) -> Bool {
        return start.timeIntervalSince(Date()) > self.timeBeforeSession
    }
    
    func compareTimeIntervals(_ frombooked: TimeInterval, procedure: TimeInterval) -> Bool {
        return frombooked >= procedure
    }
    
    func findPossibleTime(_ bookings: [BookingModel], _ newBook: BookingModel) -> [BookingModel] {
        var result: [BookingModel] = []
        
        for book in bookings {
            if !isTimePast(start: book.procedure.startDate) {
                result += [book]
            }
        }
        
        var filteredDates: [BookingModel] = []
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
    
    func isInTimeLimits(date: Date, procedureLength: TimeInterval) -> Bool {
        
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
    
    func isBookingPossible(bookings: [BookingModel], date: Date) -> Bool {
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
    
    func calculateTimeChunks(dateChunks: [BookingModel], start: Date, end: Date) -> [Date: TimeInterval] {
        
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
