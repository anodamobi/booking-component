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

protocol BookingVCDelegate: class {
    func removeObject(item: BookingModel, from list: [BookingModel])
}

class BookingVC: DayViewController, EventHandlerDelegate {
    
    var bookings: [BookingModel] = []
    var businessTime = BusinessTime()
    var procedureLength: TimeInterval!
    var procedureType: ProcedureType!
    var preservationTime: TimeInterval!
    
    var vendor: VendorModel!
    var currentUser: ClientModel!
    weak var delegate: BookingVCDelegate?
    
    private let eventHandler = EventHandler()
    private var serviceProviderIndex: Int = 0
    
    init(_ model: BookViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vendor = model.vendor
        self.procedureType = model.procedureType
        self.currentUser = model.client
        self.serviceProviderIndex = model.serviceProviderIndex.rawValue
        
        preservationTime = vendor.bookingSettings.prereservationTimeGap
        
        procedureLength = vendor.serviceProviders[serviceProviderIndex].availableProcedureTypes[procedureType]?.procedureDuration
        bookings = vendor.serviceProviders[serviceProviderIndex].bookings
        
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
        
        title = "select.date.time".localized
        navigationController?.navigationBar.barTintColor = style.header.backgroundColor
        navigationController?.navigationBar.tintColor = .cmpMidGreen
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.cmpGunmetal,
                                                                   .font: UIFont.cmpTextStyleFont() ?? UIFont.systemFont(ofSize: 17.0)]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        dayView.autoScrollToFirstEvent = false

        eventHandler.bookingDelegate = self
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
        event.text = "non-business.hours".localized
        event.textColor = .cmpCoolGrey
        
        let endDayEvent = Event()
        let hoursTilEnd = 24 - vendor.endTime.component(.hour)
        let workingHours = vendor.endTime.component(.hour) - vendor.startTime.component(.hour)
        let beginning = date.add(TimeChunk.dateComponents(hours:workingHours + duration))
        let period = TimePeriod(beginning: beginning, chunk: TimeChunk.dateComponents(hours: hoursTilEnd))
        endDayEvent.datePeriod = period
        endDayEvent.color = .cmpPaleGreyThree
        endDayEvent.text = "non-business.hours".localized
        endDayEvent.textColor = .cmpCoolGrey
        
        events.append(event)
        events.append(endDayEvent)

        
        for book in bookings {
            
            let bookedEvent = Event()
            let eventTimePeriod = TimePeriod(beginning: book.procedure.startDate, end: book.procedure.endDate)
            bookedEvent.datePeriod = eventTimePeriod
            bookedEvent.text = "busy".localized
            bookedEvent.textColor = .cmpCoolGrey
            bookedEvent.backgroundColor = .cmpBrownishOrange5
            
            if book.client.userID == currentUser.userID {
                bookedEvent.textColor = .white
                bookedEvent.backgroundColor = .cmpMidGreen75
                let procedureName = (vendor.serviceProviders[serviceProviderIndex].availableProcedureTypes[procedureType]?.procedureName) ?? procedureType.rawValue.capitalized
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
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        
        for book in bookings {
            if book.client.userID == currentUser.userID {
                
                if let eventBeginning = eventView.descriptor?.datePeriod.beginning {
                    
                    if book.procedure.startDate.compare(eventBeginning) == .orderedSame {
                        delegate?.removeObject(item: book, from: bookings)
                        break
                    }
                }
            }
        }
    }
    
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
            
            let booking = BookingModel()
            booking.client = currentUser
            booking.eventDate = selectedDate
            booking.procedure.startDate = selectedDate
            
            let timeGap = vendor.bookingSettings.timeGap
            booking.procedure.endDate = selectedDate.addingTimeInterval(procedureLength + timeGap)
            eventHandler.receiveCurrent(bookings: bookings,
                                        businessTime: businessTime,
                                        newBook: booking)
        }
    }
 
    func add(booking: BookingModel) {
        
        bookings += [booking]
        reloadData()
    }
    
    func resetPanGesture() {
        
    }
}

