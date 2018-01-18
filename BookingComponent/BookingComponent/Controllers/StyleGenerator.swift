//
//  StyleGenerator.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/18/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import CalendarKit

struct StyleGenerator {
    static func defaultStyle() -> CalendarStyle {
        return CalendarStyle()
    }
    
    static func appStyle() -> CalendarStyle {
        let orange = UIColor.orange
        let light = UIColor.lightGray
        let white = UIColor.white
        
        let selector = DaySelectorStyle()
        selector.activeTextColor = .white
        selector.inactiveTextColor = .cmpGunmetal
        selector.selectedBackgroundColor = light
        selector.todayActiveBackgroundColor = .cmpMidGreen
        selector.todayInactiveTextColor = orange
        
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = white
        daySymbols.weekendColor = light
        
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = .cmpCoolGrey
        
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = .white
        
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = .cmpDarkPeach
        timeline.lineColor = light
        timeline.timeColor = light
        timeline.backgroundColor = .white
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
}
