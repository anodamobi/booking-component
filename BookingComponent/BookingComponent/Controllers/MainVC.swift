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


class MainVC: DayViewController {
    
    var bookings: [Booking] = []
    
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
        
//        let newEvent = Event()
//        let newPeriod = TimePeriod(beginning: setup(date: stringDateFromDate() + "T10:00 AM"), end: setup(date: stringDateFromDate() + "T01:00 PM"))
//        newEvent.color = .cmpMidGreen
//        newEvent.text = "Test event"
//        newEvent.textColor = .cmpCoolGrey
//        newEvent.datePeriod = newPeriod
        events.append(event)
        events.append(endDayEvent)
//        events.append(newEvent)
//        var date = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
//        var events = [Event]()
//
//        for i in 0...5 {
//            let event = Event()
//            let duration = Int(arc4random_uniform(160) + 60)
//            let datePeriod = TimePeriod(beginning: date,
//                                        chunk: TimeChunk.dateComponents(minutes: duration))
//
//            event.datePeriod = datePeriod
//            var info = data[Int(arc4random_uniform(UInt32(data.count)))]
//            info.append("\(datePeriod.beginning!.format(with: "dd.MM.YYYY"))")
//            info.append("\(datePeriod.beginning!.format(with: "HH:mm")) - \(datePeriod.end!.format(with: "HH:mm"))")
//            event.text = info.reduce("", {$0 + $1 + "\n"})
//            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//
//            // Event styles are updated independently from CalendarStyle
//            // hence the need to specify exact colors in case of Dark style
//            if currentStyle == .Dark {
//                event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
//                event.backgroundColor = event.color.withAlphaComponent(0.6)
//            }
//
//            events.append(event)
//
//            let nextOffset = Int(arc4random_uniform(250) + 40)
//            date = date.add(TimeChunk.dateComponents(minutes: nextOffset))
//            event.userInfo = String(i)
//        }
        
        return events
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

