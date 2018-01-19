//
//  MainVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CalendarKit
import DateToolsSwift

class MainVC: DayViewController, EventHandlerDelegate {
    
    var bookings: [Booking] = []
    var businessTime = BusinessTime()
    var procedureLength: TimeInterval = 60 * 60
    
    private let eventHandler = EventHandler()
    private var recognizer: UITapGestureRecognizer!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        recognizer = UITapGestureRecognizer(target: self, action: #selector(addNewBooking))
        dayView.state?.move(to: Date())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var style: CalendarStyle!
        style = StyleGenerator.appStyle()
        updateStyle(style)
        
        title = "Select Date and Time".localized
        navigationController?.navigationBar.barTintColor = style.header.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.cmpGunmetal]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        dayView.autoScrollToFirstEvent = false
        
        self.dayView.addGestureRecognizer(recognizer)

        eventHandler.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // This will be used later. No panic.
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        let event = Event()
        let duration = 8
        let datePeriod = TimePeriod(beginning: date, chunk: TimeChunk.dateComponents(hours: duration))
        event.datePeriod = datePeriod
        event.color = .cmpPaleGreyThree
        event.text = "Non-business hours"
        event.textColor = .cmpCoolGrey
        
        let endTime = date.add(TimeChunk.dateComponents(hours:16))
        let endDayEvent = Event()
        let period = TimePeriod(beginning: endTime, chunk: TimeChunk.dateComponents(hours: 8))
        endDayEvent.datePeriod = period
        endDayEvent.color = .cmpPaleGreyThree
        endDayEvent.text = "Non-business hours"
        endDayEvent.textColor = .cmpCoolGrey
        
        events.append(event)
        events.append(endDayEvent)
        
        setupBusinessHours()
        
        for book in bookings {
            let bookedEvent = Event()
            let eventTimePeriod = TimePeriod(beginning: book.procedure.startDate, end: book.procedure.endDate)
            bookedEvent.datePeriod = eventTimePeriod
            bookedEvent.text = "Busy"
            bookedEvent.textColor = .cmpCoolGrey
            bookedEvent.backgroundColor = .cmpBrownishOrange5
            
            if book.client.userID == "current_user_name" { // keep current userID in defaults.
                bookedEvent.textColor = .white
                bookedEvent.backgroundColor = .cmpMidGreen75
            }
            events.append(bookedEvent)
        }
        
        return events
    }
    
    func setupBusinessHours() {
        let today = Date()
        let date = stringDateFromDate(today)
        let startDate = setup(date: date + "T8:00")
        let endDate = setup(date: date + "T18:00")
        businessTime.startDate = startDate
        businessTime.endDate = endDate
    }
    
    // MARK: DayViewDelegate
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        //    print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        //    print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayViewDidSelectEventView(_ eventview: EventView) {
        print("Event has been selected: \(String(describing: eventview.descriptor?.datePeriod))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        print("Event has been longPressed:")
    }
    
//    MARK: Helpers
    
    fileprivate func procedure(start: String, end: String) -> Procedure {
        var proc = Procedure()
        proc.startDate = setup(date: start)
        proc.endDate = setup(date: end).addingTimeInterval(15*60)
        return proc
    }
    
    fileprivate func setup(date: String) -> Date {
        return Date.date(from: date, timeFormat: "yyyy-MM-dd'T'H:mm")!
    }
    
    fileprivate func stringDateFromDate(_ date: Date? = nil) -> String {
        if date == nil {
            return Date().dateFormat()
        } else {
            return (date?.dateFormat())!
        }
    }
    
    fileprivate func fullDateStringFrom(_ date: Date) -> String {
        return date.dateTimeFormat()
    }
    
    override func dayViewDidLongPressTimelineAtHour(_ hour: Int) {
        if let selectedDate = dayView.state?.selectedDate.add(TimeChunk.dateComponents(hours:hour)) {
            let booking = Booking()
            booking.when = selectedDate
            booking.procedure.startDate = selectedDate
            booking.procedure.endDate = selectedDate.addingTimeInterval(procedureLength)
            eventHandler.receiveCurrent(bookings: bookings, businessTime: businessTime, newBook: booking)
        }
    }
    
    func getDateFromTable() -> Date {
        return (dayView.state?.selectedDate)!
    }
    
//    MARK: addEventDelegate
    
    @objc func addNewBooking() {
//        let selectedDate = getDateFromTable()
//        booking.when = selectedDate
//        booking.procedure.startDate = selectedDate
//        booking.procedure.endDate = selectedDate.addingTimeInterval(procedureLength)
//        eventHandler.receiveCurrent(bookings: bookings, businessTime: businessTime, newBook: booking)
    }
 
    func add(booking: Booking) {
        
        bookings += [booking]
        reloadData()
    }
    
    func resetPanGesture() {
        
    }
}

