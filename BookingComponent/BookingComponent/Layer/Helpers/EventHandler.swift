//
//  EventHandler.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/19/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

protocol EventHandlerDelegate: class {
    
    func add(booking: Booking)
    func resetPanGesture()
}

protocol EventSelectiveHandlerDelegate: class {
    func availableTimeChunks(_ intervals: [Date: TimeInterval])
}

class EventHandler {
    
    weak var bookingDelegate: EventHandlerDelegate?
    weak var selectiveDelegate: EventSelectiveHandlerDelegate?
    let controller: BookingController = BookingController()
    
//    MARK: entrancePoint
    
    func receiveCurrent(bookings: [Booking],
                        businessTime: BusinessTime,
                        newBook: Booking) {
        
        controller.update(booked: bookings,
                          startDate: businessTime.startDate,
                          endDate: businessTime.endDate,
                          selectedDate: newBook.procedure.startDate)
        
        if controller.isPossibleToBook(newBook: newBook) {
            bookingDelegate?.add(booking: newBook)
        } else {
            bookingDelegate?.resetPanGesture()
        }
    }
    
    func receiveCurrent(bookings: [Booking],
                        businessTime: BusinessTime,
                        preservationTime: TimeInterval,
                        selectedDate: Date) {
        
        controller.timeBeforeSession = preservationTime
        controller.update(booked: bookings,
                          startDate: businessTime.startDate,
                          endDate: businessTime.endDate)
        
        let intervlas = controller.possibleChunks(for: selectedDate)
        selectiveDelegate?.availableTimeChunks(intervlas)
        
    }
}
