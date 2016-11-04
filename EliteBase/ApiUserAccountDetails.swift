//
//  UserAccountDetails.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/5/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiUserAccountDetails{
    open var firstName : String!
    open var lastName : String!
    open var email : String!
    open var displayPassword : String!
	open var actualPassword : String!
    open var phoneNumber: String?
	open var yearOfBirth : Int?
    open var streetAddress : String!
    open var city : String!
    open var state: String!
    open var zip : String!
    open var hourlyRate : Int!
    open var travelRadius : Int!
    open var rating : Float!
    open var numberOfRatings : Int!
    open var imageUrl : String?
    open var qualifications        : [ApiTutorQualification]!
	open var languages : String?
    open var hasLocation : Bool!
    
    open var tutorId: String?
	
	public init(){
	}
	
    open func toDictionary(_ userId: String, tutorId: String?) -> [String: AnyObject]{
        
        var dict = [String: AnyObject]()
        
        dict["userId"]        = userId as AnyObject?
        dict["firstName"]     = firstName as AnyObject?
        dict["lastName"]      = lastName as AnyObject?
        dict["email"]         = email! as AnyObject?
        dict["password"]      = actualPassword! as AnyObject?
        dict["phoneNumber"]   = phoneNumber as AnyObject?
        dict["yearOfBirth"]   = yearOfBirth as AnyObject?
        dict["streetAddress"] = streetAddress as AnyObject?
        dict["city"]          = city as AnyObject?
        dict["state"]         = state as AnyObject?
        dict["zip"]           = zip as AnyObject?
        dict["hourlyRate"]    = hourlyRate as AnyObject?
        dict["travelRadius"]  = travelRadius as AnyObject?
        dict["imageUrl"]      = imageUrl as AnyObject?
		
		if(tutorId != nil){
			dict["tutorId"]       = tutorId as AnyObject?
			dict["languages"]	  = languages as AnyObject?
			dict["qualifications"] = qualifications.map({ qual in return qual.toDictionary() }) as AnyObject?
		}
		
        return dict
    }
}
