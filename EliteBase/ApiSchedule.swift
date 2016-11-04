//
//  Schedule.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/1/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import Foundation


open class ApiSchedule {

	open var activeMonday : Bool = false
	open var activeTuesday : Bool = false
	open var activeWednesday : Bool = false
	open var activeThursday : Bool = false
	open var activeFriday : Bool = false
	open var activeSaturday : Bool = false
	open var activeSunday : Bool = false
	
	open var startHour : Int
	open var startMinute : Int = 0
	open var endHour : Int
	open var endMinute : Int = 0
	
	open var isActive = false
	open var timeZone = "UTC"
	open var tutorId : String!
	open var scheduleId : String!
	open var startsOn : Date!
	
	public init(startHour : Int, startMinute : Int, endHour : Int, endMinute : Int){
		self.startHour = startHour
		self.startMinute = startMinute
		self.endHour = endHour
		self.endMinute = endMinute
	}
	
	public init(){
		self.startHour = 9 //9am
		self.endHour = 17 //5 pm
	}
	
	open func toJSONArray()-> [String: NSObject]{
		
		let scheduleData :[String : NSObject] = [
			"activeMonday" : activeMonday as NSObject,
			"activeTuesday" : activeTuesday as NSObject,
			"activeWednesday" : activeWednesday as NSObject,
			"activeThursday" : activeThursday as NSObject,
			"activeFriday" : activeFriday as NSObject,
			"activeSaturday" : activeSaturday as NSObject,
			"activeSunday" : activeSunday as NSObject,
			"startHour" : startHour as NSObject,
			"startMinute" : startMinute as NSObject,
			"endHour" : endHour as NSObject,
			"endMinute" : endMinute as NSObject,
			"timeZone" : timeZone as NSObject,
			"tutorId" : tutorId as NSObject,
			"startsOn" : startsOn.millisecondsSince1970() as NSObject
		]
		
		return scheduleData
	}
}
