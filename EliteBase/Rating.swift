//
//  Rating.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 12/29/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import Foundation

public final class Rating: NSObject {
    public var sessionId      : String!
    public var tutorId        : String!
    public var value          : Float!
    public var enteredOn      : Double!
    public var customerUserId : String!
    public var comments       : String?
	public var blockId		: String?
    
    public func toDictionary() -> [String: AnyObject]{
        var dict = [String: AnyObject]()
        
        dict["sessionId"]      = sessionId! as AnyObject?
        dict["tutorId"]        = tutorId! as AnyObject?
        dict["value"]          = value! as AnyObject?
        dict["enteredOn"]      = enteredOn! as AnyObject?
        dict["customerUserId"] = customerUserId! as AnyObject?
        dict["comments"]       = comments as AnyObject?
		dict["blockId"]		= blockId as AnyObject?
        
        return dict
    }
}
