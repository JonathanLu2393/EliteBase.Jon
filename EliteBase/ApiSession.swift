//
//  Session.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/29/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiSession {
	open var bookingId : String!
	open var tutorId : String!
	open var scheduledStartTime : Date!
	open var scheduledEndTime : Date!
	open var startTime : Date?
	open var endTime : Date?
	open var finished : Bool = false
	open var userId : String!
	open var sessionId : String!
}
