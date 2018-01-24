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
    
//    MARK: entrancePoint
    
    func receiveCurrent(bookings: [Booking],
                        businessTime: BusinessTime,
                        newBook: Booking,
                        currentDate: Date) {
        
        controller.update(booked: bookings,
                          startDate: businessTime.startDate,
                          endDate: businessTime.endDate,
                          selectedDate: currentDate)
        
        if controller.isPossibleToBook(newBook: newBook) {
            delegate?.add(booking: newBook)
        } else {
            delegate?.resetPanGesture()
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
        
        let interlvas = controller.possibleChunks(for: selectedDate)
        delegate?.availableTimeChunks(interlvas)
        
    }
}
