//
//  StyleGenerator.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/18/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import CalendarKit

struct StyleGenerator {
    static func defaultStyle() -> CalendarStyle {
        return CalendarStyle()
    }
    
    static func appStyle() -> CalendarStyle {
        let paleGrey = UIColor.cmpPaleGreyTwo
        let midGreen = UIColor.cmpMidGreen
        let gunMetal = UIColor.cmpGunmetal
        let coolGrey = UIColor.cmpCoolGrey
        
        let selector = DaySelectorStyle()
        selector.activeTextColor = .white
        selector.inactiveTextColor = gunMetal
        selector.selectedBackgroundColor = midGreen
        selector.todayActiveBackgroundColor = midGreen
        selector.todayInactiveTextColor = gunMetal
        
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = gunMetal
        daySymbols.weekendColor = .cmpWarmGrey
        
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = coolGrey
        
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = .white
        
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = .cmpDarkPeach
        timeline.lineColor = paleGrey
        timeline.timeColor = coolGrey
        timeline.backgroundColor = .white
        timeline.dateStyle = .twelveHour
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
}
