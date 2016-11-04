//
//  TutorSearchResult.swift
//  elitetutoring
//
//  Created by Eric Heitmuller on 8/4/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

import Foundation

public final class TutorSearchResult : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    public var tutorId      : String!
    public var firstName    : String
    public var lastName     : String
    public var imageUrl     : String = ""
    public var hourlyRate   : Double = 0
    public var city         : String?
    public var state        : String?
    public var zip          : String?
    public var rating       : Float = 0
	public var calculatedRate : Double = 0
    
    public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: Any] else { return nil }
		
        self.tutorId      = representation["_id"] as! String
        self.firstName    = representation["firstName"] as! String
        self.lastName     = representation["lastName"] as! String
        self.rating       = representation["rating"] as! Float
        self.imageUrl     = representation["imageUrl"] as! String
        self.hourlyRate   = representation["hourlyRate"] as! Double
        self.city         = representation["city"] as? String
        self.state        = representation["state"] as? String
        self.zip          = representation["zip"] as? String
		self.calculatedRate = representation["calculatedRate"] as! Double
    }
}
