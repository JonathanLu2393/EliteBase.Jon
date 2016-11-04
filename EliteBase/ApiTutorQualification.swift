//
//  TutorQualification.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/8/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public func == (lhs: ApiTutorQualification, rhs: ApiTutorQualification) -> Bool {
    if lhs.subjectId == rhs.subjectId &&
        lhs.subjectName == rhs.subjectName {
            return true
    }
    return false
}

public func != (lhs: ApiTutorQualification, rhs: ApiTutorQualification) -> Bool {
    if lhs.subjectId != rhs.subjectId &&
        lhs.subjectName != rhs.subjectName {
            return true
    }
    return false
}

public final class ApiTutorQualification: NSObject{
    
    public var subjectId : String!
    public var parentSubjectId : String?
    public var eliteVerified : Bool!
    public var subjectName : String!
    
    public init(subjectId: String, parentSubjectId: String?, subjectName: String, eliteVerified: Bool){
        self.subjectId = subjectId
        self.parentSubjectId = parentSubjectId
        self.subjectName = subjectName
        self.eliteVerified = eliteVerified
    }
    
    public func toDictionary() -> [String: AnyObject]{
        
        var dict = [String: AnyObject]()
        
        dict["subjectId"]       = subjectId as AnyObject?
        dict["parentSubjectId"] = parentSubjectId as AnyObject?
        dict["eliteVerified"]   = eliteVerified as AnyObject?
        dict["subjectName"]     = subjectName as AnyObject?
        
        return dict
    }
}
