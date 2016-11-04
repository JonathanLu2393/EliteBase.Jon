//
//  BookingDetails.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/11/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//


import Foundation
import SwiftyJSON

public final class ApiBookingDetails : NSObject, ResponseObjectSerializable {
	
	public var subjects : String!
	public var location : String!
	public var startTime : Date!
	public var endTime : Date!
	public var titleName : String!
	public var phone : String!
	public var titleImageUrl : String!
	public var bookingId : String!
	public var sessionId : String?
	public var completed : Bool!
	
	public init?(response: HTTPURLResponse, representation: Any) {
		super.init()
		
		if(response.statusCode != 200){
			return nil
		}
		guard
			let representation = representation as? [String: Any] else { return nil }
		
		let dictionary = representation["data"] as! [String : AnyObject]
		
		self.bookingId = dictionary["bookingId"] as! String
		self.titleImageUrl     = dictionary["titleImageUrl"] as! String
		self.phone  = dictionary["phone"] as! String
		self.titleName = dictionary["titleName"] as! String
		
		let endTimeString = dictionary["endTime"] as! String
		self.endTime = CalendarUtilities.stringToNSDate(endTimeString)
		
		let startTimeString = dictionary["startTime"] as! String
		self.startTime     = CalendarUtilities.stringToNSDate(startTimeString)
		
		self.location  = dictionary["location"] as! String
		self.subjects = dictionary["subjects"] as! String
		self.sessionId = dictionary["sessionId"] as? String
		self.completed = dictionary["completed"] as? Bool ?? false
	}
}
