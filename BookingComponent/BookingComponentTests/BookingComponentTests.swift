//
//  BookingComponentTests.swift
//  BookingComponentTests
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import BookingComponent

class BookingComponentTests: XCTestCase {
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var bookingController: BookingController?
    
    override func setUp() {
        super.setUp()
        startDate = setup(date: "2018-01-17T8:00")
        endDate = setup(date: "2018-01-17T18:00")
    }
    
    override func tearDown() {
        bookingController = nil
        startDate = Date()
        endDate = Date()
        super.tearDown()
    }
    
    func testWholeTableFree() {
        
        let book = Booking()
        book.procedure = procedure(start: "2018-01-17T9:00", end: "2018-01-17T10:00")
        bookingController = BookingController(booked: [], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController?.isPossibleToBook(newBook: book)
        
        expect(intervals != nil).to(beTrue())
        expect(intervals?.first == self.endDate.timeIntervalSince(self.startDate)).to(beTrue())
        
    }
    
    func testWholeTableSet() {
        
        let book1 = Booking()
        book1.procedure = procedure(start: "2018-01-17T8:30", end: "2018-01-17T10:30")
        let book2 = Booking()
        book2.procedure = procedure(start: "2018-01-17T11:00", end: "2018-01-17T12:00")
        let book3 = Booking()
        book3.procedure = procedure(start: "2018-01-17T12:30", end: "2018-01-17T14:00")
        let book4 = Booking()
        book4.procedure = procedure(start: "2018-01-17T14:15", end: "2018-01-17T16:30")
        let book5 = Booking()
        book5.procedure = procedure(start: "2018-01-17T17:00", end: "2018-01-17T18:00")
        
        let newBook = Booking()
        newBook.procedure = procedure(start: "2018-01-17T9:00", end: "2018-01-17T10:00")
        
        bookingController = BookingController(booked: [book1, book2, book3, book4, book5], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController?.isPossibleToBook(newBook: newBook)
        
        expect(intervals != nil).to(beTrue())
        for interval in intervals! {
            expect(interval < newBook.procedure.procedureLength()).to(beTrue())
        }
    }
    
    func testPossibleReservetaionTime() {
        
        let book1 = Booking()
        book1.procedure = procedure(start: "2018-01-17T8:30", end: "2018-01-17T10:30")
        let book2 = Booking()
        book2.procedure = procedure(start: "2018-01-17T11:00", end: "2018-01-17T12:00")
        let book3 = Booking()
        book3.procedure = procedure(start: "2018-01-17T12:30", end: "2018-01-17T14:00")
        let book4 = Booking()
        book4.procedure = procedure(start: "2018-01-17T14:15", end: "2018-01-17T16:30")
        
        let newBook = Booking()
        newBook.procedure = procedure(start: "2018-01-17T9:00", end: "2018-01-17T10:00")
        
        bookingController = BookingController(booked: [book1, book2, book3, book4], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController?.isPossibleToBook(newBook: newBook)
        
        expect(intervals != nil).to(beTrue())
        
        for index in 0..<intervals!.count {
            if intervals![index] >= newBook.procedure.procedureLength() {
                expect(intervals![index] >= newBook.procedure.procedureLength()).to(beTrue())
            } else {
                expect(intervals![index] < newBook.procedure.procedureLength()).to(beTrue())
            }
        }
    }
    
    func testBookInPast() {
        let newBook = Booking()
        newBook.procedure = procedure(start: "2018-01-16T16:00", end: "2018-01-16T17:00")
        
        bookingController = BookingController(booked: [], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController?.isPossibleToBook(newBook: newBook)
        expect(intervals!.count <= 0 || intervals == nil).to(beTrue())
    }
    
    func procedure(start: String, end: String) -> Procedure {
        var proc = Procedure()
        proc.startDate = setup(date: start)
        proc.endDate = setup(date: end).addingTimeInterval(15*60)
        return proc
    }
    
    func setup(date: String) -> Date {
        return Date.date(from: date, timeFormat: "yyyy-mm-dd'T'HH:mm")!
    }
}
