//
//  BookingVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CalendarKit
import DateToolsSwift

class BookingVC: DayViewController, EventHandlerDelegate {
    
    var bookings: [Booking] = []
    var businessTime = BusinessTime()
    var procedureLength: TimeInterval!
    var procedureType: ProcedureType!
    var preservationTime: TimeInterval!
    
    var vendor: VendorModel!
    var currentUser: ClientModel!
    
    var testVendor = TestDataGenerator.createVendor()
    
    private let eventHandler = EventHandler()
    
    init(_ vendor: VendorModel, _ procedureType: ProcedureType, _ client: ClientModel) {
        
        super.init(nibName: nil, bundle: nil)
        self.vendor = vendor
        self.procedureType = procedureType
        self.currentUser = client
        
        preservationTime = vendor.bookingSettings.prereservationTimeGap
        
        procedureLength = vendor.serviceProviders[0].availableProcedureTypes[procedureType]?.procedureDuration
        bookings = vendor.serviceProviders[0].bookings
        
        setupBusinessHours(vendor)
        
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
        navigationController?.navigationBar.tintColor = .cmpMidGreen
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.cmpGunmetal]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        dayView.autoScrollToFirstEvent = false

        eventHandler.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        
        var events = [Event]()
        let event = Event()
        let duration = vendor.startTime.component(.hour)
        let datePeriod = TimePeriod(beginning: date, chunk: TimeChunk.dateComponents(hours: duration))
        event.datePeriod = datePeriod
        event.color = .cmpPaleGreyThree
        event.text = "Non-business hours".localized
        event.textColor = .cmpCoolGrey
        
        let endDayEvent = Event()
        let hoursTilEnd = 24 - vendor.endTime.component(.hour)
        let period = TimePeriod(beginning: businessTime.endDate, chunk: TimeChunk.dateComponents(hours: hoursTilEnd))
        endDayEvent.datePeriod = period
        endDayEvent.color = .cmpPaleGreyThree
        endDayEvent.text = "Non-business hours".localized
        endDayEvent.textColor = .cmpCoolGrey
        
        events.append(event)
        events.append(endDayEvent)

        
        for book in bookings {
            let bookedEvent = Event()
            let eventTimePeriod = TimePeriod(beginning: book.procedure.startDate, end: book.procedure.endDate)
            bookedEvent.datePeriod = eventTimePeriod
            bookedEvent.text = "Busy"
            bookedEvent.textColor = .cmpCoolGrey
            bookedEvent.backgroundColor = .cmpBrownishOrange5
            
            if book.client.userID == currentUser.userID {
                bookedEvent.textColor = .white
                bookedEvent.backgroundColor = .cmpMidGreen75
                let procedureName = (vendor.serviceProviders[0].availableProcedureTypes[procedureType]?.procedureName) ?? procedureType.rawValue.capitalized
                bookedEvent.text = procedureName
            }
            events.append(bookedEvent)
        }
        
        return events
    }
    
    func setupBusinessHours(_ vendor: VendorModel) {
        businessTime.startDate = vendor.startTime
        businessTime.endDate = vendor.endTime
    }

//   MARK: DayViewDelegate
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
    }
    
    override func dayViewDidSelectEventView(_ eventview: EventView) {
        print("Event has been selected: \(String(describing: eventview.descriptor?.datePeriod))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        print("Event has been longPressed:")
    }
    
//    MARK: Helpers
    
    fileprivate func procedure(start: String, end: String) -> ProcedureDuration {
        var proc = ProcedureDuration()
        proc.startDate = setup(date: start)
        proc.endDate = setup(date: end).addingTimeInterval(15*60)
        return proc
    }
    
    fileprivate func setup(date: String) -> Date {
        return Date.date(from: date, timeFormat: "yyyy-MM-dd'T'H:mm") ?? Date()
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
            booking.client = currentUser
            booking.when = selectedDate
            booking.procedure.startDate = selectedDate
            let timeGap = vendor.bookingSettings.timeGap //TODO: Pavel - vendor's or serviceProvider's gap should be used.
            booking.procedure.endDate = selectedDate.addingTimeInterval(procedureLength + timeGap)
            eventHandler.receiveCurrent(bookings: bookings,
                                        businessTime: businessTime,
                                        newBook: booking,
                                        currentDate: selectedDate)
        }
    }
 
    func add(booking: Booking) {
        
        bookings += [booking]
        reloadData()
    }
    
    func resetPanGesture() {
        
    }
    
    func availableTimeChunks(_ intervals: [Date: TimeInterval]) {
        //Stub
    }
}

