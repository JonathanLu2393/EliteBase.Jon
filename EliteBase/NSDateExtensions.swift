//
//  NSDateExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

extension Date {
    
    public func roundToNearest30() -> Date {
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let hourComponent = (myCalendar as NSCalendar).components(.hour, from: self)
        let minuteComponent = (myCalendar as NSCalendar).components(.minute, from: self)
        
        if(minuteComponent.minute == 0 || minuteComponent.minute == 30){
            return self
        } else if((minuteComponent.minute)! > 30) {
            
            var hour = hourComponent.hour! + 1
            if(hour > 23){
                hour = 0;
            }
            let roundedDate : Date = (myCalendar as NSCalendar).date(bySettingHour: hour, minute: 0, second: 0, of: self, options: NSCalendar.Options())!
            return roundedDate
        } else {
            let roundedDate : Date = (myCalendar as NSCalendar).date(bySettingHour: hourComponent.hour!, minute: 30, second: 0, of: self, options: NSCalendar.Options())!
            return roundedDate
        }
    }
    
    public func addDays(_ numberOfDays:Int) -> Date! {
        
        var calendar : Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components : DateComponents = DateComponents()
        components.day = numberOfDays
        
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options())
    }
    
    public func addHours(_ numberOfHours: Int) -> Date!{
        var calendar : Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components : DateComponents = DateComponents()
        components.hour = numberOfHours
        
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options())
    }
    
    public func addMinutes(_ numberOfMinutes: Int) -> Date! {
        var calendar : Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components : DateComponents = DateComponents()
        components.minute = numberOfMinutes
        
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options())
    }
    
    public func addMonths(_ numberOfMonths: Int) -> Date! {
        var calendar : Calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var components : DateComponents = DateComponents()
        components.month = numberOfMonths
        
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options())
    }
    
    public func isInThePast() -> Bool {
        let now = Date()
        
        if (now.compare(self) == ComparisonResult.orderedAscending){
            return false
        }
        return true
    }
    
    public func isInThePast(_ dateToCompare: Date) -> Bool {
        
        if (dateToCompare.compare(self) == ComparisonResult.orderedAscending){
            return false
        }
        return true
    }
    
    public func dayOfWeek() -> Int {
        let myCalendar = Calendar.current
        let components = (myCalendar as NSCalendar).components(.weekday, from: self)
        return components.weekday!
        
    }
    
    public func dayOfWeekName() -> String {
        let dayOfWeek = self.dayOfWeek()
        return CalendarUtilities.dayIntToString(dayOfWeek)
    }
    
    public func toShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        return formatter.string(from: self)
    }
    
    public func toLongDateString()->String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        return formatter.string(from: self)
    }
    
    public func toLongDateTimeString()-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: self)
    }
    
    public func toShortDateTimeString()-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: self)
    }
    
    public func toShortTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: self)
    }
    
    public func millisecondsSince1970()-> Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    public func atMidnight()-> Date {
        let cal = Calendar.current
        return (cal as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: self, options: NSCalendar.Options())!
    }
    
    public func firstDayOfMonth() -> Date! {
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: self)
        return cal.date(from: components)
    }
    
    public func lastDayOfMonth()-> Date! {
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: self)
        return cal.date(from: components)?.addMonths(1).addingTimeInterval(-1) //subtracts one second
    }
    
    public func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }
    
    public func isLessThanDate(_ dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            return true
        }
        return false
    }
    
    public func equalToDate(_ dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            return true
        }
        return false
    }
    
    public func isEqualOrGreaterThanDate(_ dateToCompare: Date) -> Bool {
        if(self.equalToDate(dateToCompare)){
            return true
        }
        return self.isGreaterThanDate(dateToCompare)
    }
    
    public func isEqualOrLessThanDate(_ dateToCompare: Date) -> Bool {
        if(self.equalToDate(dateToCompare)){
            return true
        }
        return self.isLessThanDate(dateToCompare)
    }
    
    public func isEqualOrBetweenTwoDates(_ earlierDate: Date, laterDate: Date) -> Bool {
        if(self.equalToDate(earlierDate)){
            return true
        }
        return (self.isGreaterThanDate(earlierDate) && self.isLessThanDate(laterDate))
    }
    
    public func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    
    public func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    public func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    public func minuteDifference(_ compareDate: Date) -> Int {
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: self.roundToNearest30(), to: compareDate.roundToNearest30(), options: []).minute!
    }
}
