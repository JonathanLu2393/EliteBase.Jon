//
//  ApiTutorAvailability.swift
//  EliteBase
//
//  Created by Eric Heitmuller on 6/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiTutorAvailability {
	open var startTime : Date!
	open var endTime : Date!
	open var durationInMinutes : Int!
	open var timeticketIds : [ String ]!
	
	public init(startTime : Date, endTime : Date, durationInMinutes : Int, timeticketIds : [String]){
		
		self.startTime = startTime
		self.endTime = endTime
		self.durationInMinutes = durationInMinutes
		self.timeticketIds = timeticketIds
	}
}
