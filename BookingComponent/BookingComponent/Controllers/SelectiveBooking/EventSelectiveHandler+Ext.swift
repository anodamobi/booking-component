//
//  EventHandler+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/29/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

extension SelectiveVC: EventSelectiveHandlerDelegate {
    
    func availableTimeChunks(_ intervals: [Date: TimeInterval]) {
        
        let dates: [Date] = createSessionsDates(intervals)
        
        var currentDates: [Date] = []
        
        for date in dates {
            if date.compare(Date().addingTimeInterval(vendor.bookingSettings.prereservationTimeGap))  == .orderedDescending {
                currentDates += [date]
            }
        }
        
        createModels(currentDates: currentDates)
        
    }
    
    //    MARK: Helpers
    
    private func createModels(currentDates: [Date]) {
        
        let morning = sortByTime(data: currentDates, .morning).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        let day = sortByTime(data: currentDates, .day).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        let evening = sortByTime(data: currentDates, .evening).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        elementsForCollection = [morning, day, evening]
        contentView.collectionView.reloadData()
    }
    
    private func sortByTime(data: [Date], _ type: SectionType) -> [Date] {
        var dateArray: [Date] = []
        for day in data {
            if checkDayHour(day, 6, 13) && type == .morning {
                dateArray += [day]
            }
            if checkDayHour(day, 13, 18) && type == .day {
                dateArray += [day]
            }
            if checkDayHour(day, 18, 22) && type == .evening {
                dateArray += [day]
            }
        }
        return dateArray
    }
    
    private func checkDayHour(_ day: Date, _ minVal: Int, _ maxVal: Int) -> Bool {
        return day.component(.hour) >= minVal && day.component(.hour) < maxVal
    }
    
    private func createSessionsDates(_ intervals: [Date: TimeInterval]) -> [Date] {
        
        var dates: [Date] = []
        for interval in intervals {
            let possibleSessions = Int(interval.value / duration)
            for session in 0..<possibleSessions {
                let sessionStart = TimeInterval(Int(duration) * session)
                dates += [interval.key.addingTimeInterval(sessionStart)]
            }
        }
        return dates
    }
}
