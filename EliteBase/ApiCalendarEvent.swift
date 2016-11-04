//
//  CalendarEvent.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/9/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiCalendarEvent {
	open var startTime : Date!
	open var endTime : Date!
	open var hasAvailability : Bool = false
	open var hasBooking : Bool = false
    
    public init(){
        self.startTime = Date()
        self.endTime = Date()
        self.hasAvailability = true
        self.hasBooking = true
    }
}
