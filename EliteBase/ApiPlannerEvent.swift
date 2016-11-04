//
//  ApiPlannerEvent.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

public final class ApiPlannerEvent : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
	
	var title = ""
	var startTime : Date!
	var endTime: Date!
	var eventType: ApiPlannerEventType!
	var textColor = UIColor.white
	var backgroundColor : UIColor {
		get {
			if(self.eventType == ApiPlannerEventType.booking){
				return UIColor.lightGray
			}
			
			return UIColor.red
		}
	}
	var relatedId : String! // bookingId or timeticketId based on type
	
	public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: Any] else { return nil}
		
		self.title     = representation["title"] as! String
		self.startTime  = representation["startTime"] as! Date
		self.endTime = representation["endTime"] as! Date
		self.eventType = representation["eventType"] as! ApiPlannerEventType
	}
	
}
