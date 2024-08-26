//
//  CalendarExtensions.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 26/8/24.
//


import Foundation

public extension Calendar {
    static func gregorian() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Monday
        calendar.timeZone = TimeZone.current
        
        return calendar
    }
}
