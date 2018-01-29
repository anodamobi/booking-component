//
//  BookingComponentTests.swift
//  BookingComponentTests
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import BookingComponent

let day: TimeInterval = 86400
let nextDay: Date = Date().addingTimeInterval(day)

class BookingComponentTests: XCTestCase {
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var dateString: String = ""
    var bookingController = BookingController()
    
    override func setUp() {
        super.setUp()
        dateString = self.stringDateFromDate()
        startDate = setup(date: "\(dateString)T08:00+0000")
        endDate = setup(date: "\(dateString)T18:00+0000")
    }
    
    override func tearDown() {
        dateString = ""
        startDate = Date()
        endDate = Date()
        super.tearDown()
    }
    
    func testWholeTableFree() {
        
        let book = BookingModel()
        book.procedure = procedure(start: "\(dateString)T9:00", end: "\(dateString)T10:00")
        
        bookingController.update(booked: [], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: book)
        
        expect(intervals.count > 0).to(beTrue())
        expect(intervals.first == self.endDate.timeIntervalSince(self.startDate)).to(beTrue())
        
    }
    
    func testWholeTableSet() {
        
        let book1 = BookingModel()
        book1.procedure = procedure(start: "\(dateString)T8:30", end: "\(dateString)T10:30")
        let book2 = BookingModel()
        book2.procedure = procedure(start: "\(dateString)T11:00", end: "\(dateString)T12:00")
        let book3 = BookingModel()
        book3.procedure = procedure(start: "\(dateString)T12:30", end: "\(dateString)T14:00")
        let book4 = BookingModel()
        book4.procedure = procedure(start: "\(dateString)T14:15", end: "\(dateString)T16:30")
        let book5 = BookingModel()
        book5.procedure = procedure(start: "\(dateString)T17:00", end: "\(dateString)T18:00")
        
        let newBook = BookingModel()
        newBook.procedure = procedure(start: "\(dateString)T9:00", end: "\(dateString)T10:00")
        
        bookingController.update(booked: [book1, book2, book3, book4, book5], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        expect(intervals.count > 0).to(beTrue())
        for interval in intervals {
            expect(interval < newBook.procedure.duration()).to(beTrue())
        }
    }
    
    func testPossibleReservetaionTime() {
        
        let book1 = BookingModel()
        book1.procedure = procedure(start: "\(dateString)T8:30", end: "\(dateString)T10:30")
        let book2 = BookingModel()
        book2.procedure = procedure(start: "\(dateString)T11:00", end: "\(dateString)T12:00")
        let book3 = BookingModel()
        book3.procedure = procedure(start: "\(dateString)T12:30", end: "\(dateString)T14:00")
        let book4 = BookingModel()
        book4.procedure = procedure(start: "\(dateString)T14:15", end: "\(dateString)T16:30")
        
        let newBook = BookingModel()
        newBook.procedure = procedure(start: "\(dateString)T9:00", end: "\(dateString)T10:00")
        
        bookingController.update(booked: [book1, book2, book3, book4], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        expect(intervals.count > 0).to(beTrue())
        
        for index in 0..<intervals.count {
            if intervals[index] >= newBook.procedure.duration() {
                expect(intervals[index] >= newBook.procedure.duration()).to(beTrue())
            } else {
                expect(intervals[index] < newBook.procedure.duration()).to(beTrue())
            }
        }
    }
    
    func testBookInPast() {
        let newBook = BookingModel()
        newBook.procedure = procedure(start: "2018-01-16T16:00", end: "2018-01-16T17:00")
        
        bookingController.update(booked: [], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        expect(intervals.count == 0).to(beTrue())
    }
    
    func testBookRightNow() {
        let newBook = BookingModel()
        newBook.procedure = procedure(start: fullDateStringFrom(Date()),
                                      end: fullDateStringFrom(Date().addingTimeInterval(60*60)))
        let booking = BookingModel()
        booking.procedure = procedure(start: fullDateStringFrom(Date().addingTimeInterval((60 + 15) * 60)),
                                      end: fullDateStringFrom(endDate))
        bookingController.update(booked: [booking], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        expect(intervals.count == 0).to(beTrue())
    }
    
    func testBookTomorrow() {
        let newBook = BookingModel()
        let start = fullDateStringFrom(Date().addingTimeInterval(day))
        let end = fullDateStringFrom(Date().addingTimeInterval(day + 3600))
        newBook.procedure = procedure(start: start, end: end)
        
        bookingController.update(booked: [], startDate: startDate, endDate: endDate)
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        expect(intervals.count > 0).to(beTrue())
    }
    
    func testBookTomorrowNotEmtyTable() {
        let newBook = BookingModel()
        let start = fullDateStringFrom(nextDay)
        let end = fullDateStringFrom(Date().addingTimeInterval(day + 3600))
        
        let stringNextDay = stringDateFromDate(nextDay)
        let dayStart = stringNextDay + "T8:00"
        let dayEnd = stringNextDay + "T18:00"
        newBook.procedure = procedure(start: start, end: end)
        
        let book1 = BookingModel()
        book1.procedure = procedure(start: "\(stringNextDay)T8:30", end: "\(stringNextDay)T10:30")
        let book2 = BookingModel()
        book2.procedure = procedure(start: "\(stringNextDay)T11:00", end: "\(stringNextDay)T12:00")
        let book3 = BookingModel()
        book3.procedure = procedure(start: "\(stringNextDay)T12:30", end: "\(stringNextDay)T14:00")
        let book4 = BookingModel()
        book4.procedure = procedure(start: "\(stringNextDay)T14:15", end: "\(stringNextDay)T16:30")
        
        bookingController.update(booked: [book1, book2, book3, book4],
                                 startDate: setup(date: dayStart),
                                 endDate: setup(date: dayEnd))
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        for index in 0..<intervals.count {
            if intervals[index] >= newBook.procedure.duration() {
                expect(intervals[index] >= newBook.procedure.duration()).to(beTrue())
            } else {
                expect(intervals[index] < newBook.procedure.duration()).to(beTrue())
            }
        }
    }
    
    func testNextDayIsFull() {
        let newBook = BookingModel()
        let start = fullDateStringFrom(nextDay)
        let end = fullDateStringFrom(Date().addingTimeInterval(day + 3600))
        
        let stringNextDay = stringDateFromDate(nextDay)
        let dayStart = stringNextDay + "T8:00"
        let dayEnd = stringNextDay + "T18:00"
        newBook.procedure = procedure(start: start, end: end)
        
        let book1 = BookingModel()
        book1.procedure = procedure(start: "\(stringNextDay)T8:30", end: "\(stringNextDay)T10:30")
        let book2 = BookingModel()
        book2.procedure = procedure(start: "\(stringNextDay)T11:00", end: "\(stringNextDay)T12:00")
        let book3 = BookingModel()
        book3.procedure = procedure(start: "\(stringNextDay)T12:30", end: "\(stringNextDay)T14:00")
        let book4 = BookingModel()
        book4.procedure = procedure(start: "\(stringNextDay)T14:15", end: "\(stringNextDay)T16:30")
        let book5 = BookingModel()
        book5.procedure = procedure(start: "\(stringNextDay)T17:00", end: "\(stringNextDay)T18:00")
        
        bookingController.update(booked: [book1, book2, book3, book4, book5],
                                 startDate: setup(date: dayStart),
                                 endDate: setup(date: dayEnd))
        
        let intervals = bookingController.isPossibleToBook(newBook: newBook)
        
        expect(intervals.count > 0).to(beTrue())
        for interval in intervals {
            expect(interval < newBook.procedure.duration()).to(beTrue())
        }
    }
    
    
//    MARK: Helpers
    
    func procedure(start: String, end: String) -> Procedure {
        var proc = Procedure()
        proc.startDate = setup(date: start)
        proc.endDate = setup(date: end).addingTimeInterval(15*60)
        return proc
    }
    
    func setup(date: String) -> Date {
        return Date.date(from: date, timeFormat: "yyyy-MM-dd'T'HH:mm a")!
    }
    
    func stringDateFromDate(_ date: Date? = nil) -> String {
        if date == nil {
            return Date().dateFormat()
        } else {
            return (date?.dateFormat())!
        }
    }
    
    func fullDateStringFrom(_ date: Date) -> String {
        return date.dateTimeFormat()
    }
}
