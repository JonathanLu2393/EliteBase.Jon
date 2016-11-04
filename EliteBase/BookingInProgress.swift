//
//  Booking.swift
//  elitetutoring
//
//  Created by Eric Heitmuller on 7/22/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public final class BookingInProgress: NSObject {
    
    public var masterSubject: ApiSubject?
    public var childSubject: ApiSubject?
	
	public var coordinate : CLLocationCoordinate2D?
    public var confirmedAddress : CLPlacemark?
    public var enteredAddress : String?
	
    public var startTime : Date?
    public var endTime : Date?
    
    public var claimedTimeTickets : [ApiTimeTicket]?
    public var bookingId : String?
    public var tutorId : String?
    public var tutorFirstName : String?
    public var tutorLastName : String?
    
    public var customerUserId : String?
	public var desiredDuration : Int?
	public var desiredDate : Date?
	public var desiredTimeTicketIds : [String]?
    
    public var rebookFlag : Bool?
	
	public func toDictionary() -> [String: AnyObject]{
		var dict = [String: AnyObject]()
		
		var subjectArrayString = "[" + masterSubject!.toJson()
        subjectArrayString += "," + childSubject!.toJson()
		
		subjectArrayString += "]"

		dict["subjects"] = subjectArrayString as AnyObject?
		
		if(confirmedAddress != nil){
			dict["confirmedAddress"]  = confirmedAddress!.stringFromPlacemark() as AnyObject?
		}
		if(enteredAddress != nil){
			dict["enteredAddress"] = enteredAddress as AnyObject?
            dict["confirmedAddress"] = enteredAddress as AnyObject?
		}
		dict["startTime"] = (startTime!.timeIntervalSince1970 * 1000).description as AnyObject?
		dict["endTime"] = (endTime!.timeIntervalSince1970 * 1000).description as AnyObject?
		
		var claimedTimeTicketsString = "["
		if let tickets = claimedTimeTickets{
			for timeticket in tickets{
				claimedTimeTicketsString += timeticket.toJson() + ","
			}
			claimedTimeTicketsString = String(claimedTimeTicketsString.characters.dropLast())
		}
		claimedTimeTicketsString += "]"
		
		dict["claimedTimeTickets"] = claimedTimeTicketsString as AnyObject?
		
		dict["tutorId"] = tutorId! as AnyObject?
		dict["tutorFirstName"] = tutorFirstName! as AnyObject?
		dict["tutorLastName"] = tutorLastName! as AnyObject?
		dict["customerUserId"] = customerUserId! as AnyObject?
        dict["rebookFlag"] = rebookFlag as AnyObject?
		
		return dict
	}
}
