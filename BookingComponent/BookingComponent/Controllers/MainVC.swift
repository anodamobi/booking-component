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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStyle(StyleGenerator.appStyle())
        dayView.autoScrollToFirstEvent = false
    }

    
    // This will be used later. No panic.
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let time = date.add(TimeChunk.dateComponents(hours: 8))
        var events = [Event]()
        let event = Event()
        let duration = 8
        let datePeriod = TimePeriod(beginning: time, chunk: TimeChunk.dateComponents(hours: duration))
        event.datePeriod = datePeriod
        event.color = .cmpPaleGreyThree
        
        events.append(event)
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
        print("Event has been selected: ")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        print("Event has been longPressed:")
    }
}

