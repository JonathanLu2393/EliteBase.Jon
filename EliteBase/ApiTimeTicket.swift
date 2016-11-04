//
//  TimeTicket.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

public final class ApiTimeTicket {
	public var timeTicketId : String!
	public var startTime : Date!
	public var endTime : Date!
	public var tutorId : String!
	public var claimed : Bool?
	public var claimedByUserId : String?
	public var claimedOn : Date?
	public var lockedByUserId: String?
	public var locked: Bool?
	public var lockedOn : Date?
	public var pricePerHour : Int!
	
	public func toJson()-> String{
		var string = "{"
		string += " \"_id\" : \"" + timeTicketId + "\","
		string += " \"startTime\" : \"" + startTime.millisecondsSince1970().description + "\",";
		string += " \"endTime\" : \"" + endTime.millisecondsSince1970().description + "\",";
		string += " \"tutorId\" : \"" + tutorId + "\",";
		string += " \"pricePerHour\" : \"" + pricePerHour.description + "\",";
		if(locked != nil){
			string += " \"locked\" : \"" + locked!.description + "\","
		}
		if(lockedByUserId != nil){
			string += " \"lockedByUserId\" : \"" + lockedByUserId! + "\","
		}
		if(lockedOn != nil){
			string += " \"lockedOn\" : \"" + lockedOn!.millisecondsSince1970().description + "\","
		}
		if(claimed != nil){
			string += " \"claimed\" : \"" + claimed!.description + "\","
		}
		if(claimedByUserId != nil){
			string += " \"claimedByUserId\" : \"" + claimedByUserId! + "\","
		}
		if(claimedOn != nil){
			string += " \"claimedOn\" : \"" + claimedOn!.millisecondsSince1970().description + "\","
		}
		
		string = String(string.characters.dropLast()) //remove the ,
		
		string += "}"
		
		return string
	}
}
