//
//  ApiTutorDetailsWithAvailability.swift
//  EliteBase
//
//  Created by Eric Heitmuller on 6/9/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON

open class ApiTutorDetailsWithAvailability : NSObject, ResponseObjectSerializable{
	
	open var tutorId               : String!
	open var firstName             : String!
	open var lastName              : String!
	open var imageUrl              : String!
	open var hourlyRate            : Double!
	open var city                  : String!
	open var state                 : String!
	open var zip                   : String!
	open var rating                : Float!
	open var calculatedRate		  : Double!
	open var travelRadius          : Int!
	open var numberOfRatings       : Int!
	open var education             : String!
	open var backgroundCheckPassed : Bool!
	open var languages             : String!
	open var qualifications        : [ApiTutorQualification]!
	open var availabilities		 : [ApiTutorAvailability]

	public required init?(response: HTTPURLResponse, representation: Any) {
		
		guard
			let representation = representation as? [String: Any],
			let data = representation["data"] as? [String : Any]
			else { return nil }
		
		self.tutorId         = data["_id"] as! String
		self.firstName       = (data as AnyObject).value(forKeyPath: "firstName") as! String
		self.lastName        = (data as AnyObject).value(forKeyPath: "lastName") as! String
		self.imageUrl        = (data as AnyObject).value(forKeyPath: "imageUrl") as! String
		self.hourlyRate      = (data as AnyObject).value(forKeyPath: "hourlyRate") as! Double
		self.city            = (data as AnyObject).value(forKeyPath: "city") as! String
		self.state           = (data as AnyObject).value(forKeyPath: "state") as! String
		self.zip             = (data as AnyObject).value(forKeyPath: "zip") as! String
		self.rating          = (data as AnyObject).value(forKeyPath: "rating") as! Float
		self.travelRadius    = (data as AnyObject).value(forKeyPath: "travelRadius") as! Int
		self.numberOfRatings = (data as AnyObject).value(forKeyPath: "numberOfRatings") as! Int
		self.education       = (data as AnyObject).value(forKeyPath: "education") as! String
		self.calculatedRate  = (data as AnyObject).value(forKeyPath: "calculatedRate") as! Double
		
		self.backgroundCheckPassed = (data as AnyObject).value(forKeyPath: "backgroundCheckPassed") as! Bool
		self.languages = (data as AnyObject).value(forKeyPath: "languages") as! String
		
		var tutorQualification = [ApiTutorQualification]()
		
		
		let quals = data["qualifications"]!
		let subjects = JSON(quals)
		
		for x in 0 ..< subjects.count {
			let subjectId = subjects[x]["subjectId"].string!
			let parentSubjectId = subjects[x]["parentSubjectId"].string
			let eliteVerified = subjects[x]["eliteVerified"].bool!
			let subjectName = subjects[x]["subjectName"].string!
			
			tutorQualification.append(ApiTutorQualification(subjectId: subjectId, parentSubjectId: parentSubjectId, subjectName: subjectName, eliteVerified: eliteVerified))
		}
		
		self.qualifications = tutorQualification
		
		var tutorAvailabilities = [ApiTutorAvailability]()
		let availabilities = JSON(data["availabilities"])
		
		self.availabilities = [ApiTutorAvailability]()
		if(availabilities.count > 0){
			for i in 0 ..< availabilities.count {
				let startTime : Date = CalendarUtilities.stringToNSDate(availabilities[i]["startTime"].string)!
				let endTime : Date = CalendarUtilities.stringToNSDate(availabilities[i]["endTime"].string)!
				let durationInMinutes : Int = availabilities[i]["durationInMinutes"].int!
				let timeticketIds : [ String ] = availabilities[i]["timeticketIds"].map({ $1.stringValue })
				
				tutorAvailabilities.append(ApiTutorAvailability(startTime : startTime, endTime : endTime, durationInMinutes: durationInMinutes, timeticketIds: timeticketIds))
			}
			
			self.availabilities = tutorAvailabilities
		}
	}
	
	
}
