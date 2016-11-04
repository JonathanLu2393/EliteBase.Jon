//
//  TutorDetails.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 8/12/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

/**
Represents details about a tutor
**/

import Foundation
import SwiftyJSON

public final class ApiTutorDetails : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var tutorId               : String!
    public var firstName             : String!
    public var lastName              : String!
    public var imageUrl              : String!
    public var hourlyRate            : Double!
    public var city                  : String!
    public var state                 : String!
    public var zip                   : String!
    public var rating                : Float!
    public var calculatedRate		  : Double!
    public var travelRadius          : Int!
    public var numberOfRatings       : Int!
    public var education             : String!
    public var backgroundCheckPassed : Bool!
    public var languages             : String!
    public var qualifications        : [ApiTutorQualification]!
    
    public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: Any] else { return nil }
		
        self.tutorId         = representation["_id"] as! String
        self.firstName       = representation["firstName"] as! String
        self.lastName        = representation["lastName"] as! String
        self.imageUrl        = representation["imageUrl"] as! String
        self.hourlyRate      = representation["hourlyRate"] as! Double
        self.city            = representation["city"] as! String
        self.state           = representation["state"] as! String
        self.zip             = representation["zip"] as! String
        self.rating          = representation["rating"] as! Float
        self.travelRadius    = representation["travelRadius"] as! Int
        self.numberOfRatings = representation["numberOfRatings"] as! Int
        self.education       = representation["education"] as! String
		self.calculatedRate  = representation["calculatedRate"] as! Double
        
        self.backgroundCheckPassed = representation["backgroundCheckPassed"] as! Bool
        self.languages = representation["languages"] as! String
        
        var tutorQualification = [ApiTutorQualification]()
        
        let subjects = JSON(representation["qualifications"]!)
        
        for x in 0 ..< subjects.count {
            let subjectId = subjects[x]["subjectId"].string!
            let parentSubjectId = subjects[x]["parentSubjectId"].string
            let eliteVerified = subjects[x]["eliteVerified"].bool!
            let subjectName = subjects[x]["subjectName"].string!
			
			tutorQualification.append(ApiTutorQualification(subjectId: subjectId, parentSubjectId: parentSubjectId, subjectName: subjectName, eliteVerified: eliteVerified))
        }

        self.qualifications = tutorQualification
    }
	
    override init() {
        
    }
}
