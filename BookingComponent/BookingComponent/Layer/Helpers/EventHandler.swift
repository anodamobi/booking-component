//
//  EventHandler.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/19/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

protocol EventHandlerDelegate {
    
    func add(booking: Booking)
    func resetPanGesture()
    func availableTimeChunks(_ intervals: [Date: TimeInterval])
}

class EventHandler {
    
    var delegate: EventHandlerDelegate?
    let controller: BookingController = BookingController()
    
    func receiveCurrent(bookings: [Booking], businessTime: BusinessTime, newBook: Booking) {
        
        controller.update(booked: bookings,
                          startDate: businessTime.startDate,
                          endDate: businessTime.endDate)
        let intervals = controller.isPossibleToBook(newBook: newBook)
        useClosestFrom(intervals: intervals, newBook: newBook, bookings: bookings)
    }
    
    func receiveCurrent(bookings: [Booking], businessTime: BusinessTime) {
        controller.update(booked: bookings,
                          startDate: businessTime.startDate,
                          endDate: businessTime.endDate)
        let interlvas = controller.possibleChunks()
        delegate?.availableTimeChunks(interlvas)
        
    }
    
    func useClosestFrom(intervals: [Date: TimeInterval], newBook: Booking, bookings: [Booking]) {
        
        var validInterval: Dictionary<Date, TimeInterval> = [:]
        for interval in intervals {
            if interval.value >= newBook.procedure.procedureLength() {
                validInterval[interval.key] = interval.value
                break
            }
        }
        setBookOrReset(validInterval, newBook: newBook)
    }
    
    func setBookOrReset(_ intervals: [Date:TimeInterval], newBook: Booking) {
    var isPossibleToSet = false
        for date in intervals {
            
            let comparisonResult = date.key.compare(newBook.procedure.startDate)
            
            if comparisonResult == .orderedSame || comparisonResult == .orderedAscending{
               // if (date.value >= newBook.procedure.procedureLength()) {
                    isPossibleToSet = true
                    delegate?.add(booking: newBook)
               // }
            }
        }
        if isPossibleToSet == false {
            self.delegate?.resetPanGesture() //TODO: for future
        }
    }
}
