//
//  EventHandler.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/19/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

protocol EventHandlerDelegate {
    
    func add(booking: Booking)
    func resetPanGesture()
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
    
    func useClosestFrom(intervals: [TimeInterval], newBook: Booking, bookings: [Booking]) {
        var validInterval: TimeInterval = 0
        for interval in intervals {
            if interval >= newBook.procedure.procedureLength() {
                validInterval = interval
                break
            }
        }
        setBookOrReset(validInterval, newBook: newBook)
    }
    
    func setBookOrReset(_ interval: TimeInterval, newBook: Booking) {
        //TODO: pavel - should contain start date.
        if newBook.procedure.procedureLength() <= interval {
            delegate?.add(booking: newBook)
        } else {
            delegate?.resetPanGesture()
        }
    }
}
