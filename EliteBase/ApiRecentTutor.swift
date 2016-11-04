//
//  ApiRecentTutor.swift
//  EliteBase
//
//  Created by Jonathan Lu on 8/8/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ApiRecentTutor : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var tutorId          : String?
    public var tutorFirstName   : String?
    public var tutorLastName    : String?
    public var tutorImageUrl    : String?
    public var startTime        : Date?
    public var endTime          : Date?
    public var bookingId        : String?
    public var confirmedAddress : String?
    public var masterSubject    : ApiSubject?
    public var childSubject     : ApiSubject?
    
    public init?(response: HTTPURLResponse, representation: Any) {
		
		guard
			let representation = representation as? [String: Any]
			else { return nil }
		
        self.tutorId        = representation["tutorId"] as? String
        self.tutorFirstName = representation["tutorFirstName"] as? String
        self.tutorLastName  = representation["tutorLastName"] as? String
        self.tutorImageUrl  = representation["tutorImageUrl"] as? String
		let startDate = representation["startTime"] as? String
        self.startTime      = CalendarUtilities.stringToNSDate(startDate)
        let endDate = representation["endTime"] as? String
        self.endTime        = CalendarUtilities.stringToNSDate(endDate)
        
        self.bookingId      = representation["bookingId"] as? String
        self.confirmedAddress = representation["confirmedAddress"] as? String
        
        let mSubject = JSON(representation["masterSubject"]!)
        let cSubject = JSON(representation["childSubject"]!)
        
        let masterSubject = ApiSubject()
        masterSubject.subjectId = mSubject["_id"].string
        masterSubject.title = mSubject["name"].string!
        masterSubject.subTitle = mSubject["info"].string!
        
        let childSubject = ApiSubject()
        childSubject.subjectId = cSubject["_id"].string
        childSubject.parentSubjectId = cSubject["parentSubjectId"].string
        childSubject.title = cSubject["name"].string!
        childSubject.subTitle = cSubject["info"].string!
        
        self.masterSubject  = masterSubject
        self.childSubject   = childSubject
    }
	
}
