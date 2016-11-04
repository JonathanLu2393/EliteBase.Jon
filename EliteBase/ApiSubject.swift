//
//  Subject.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public func == (lhs: ApiSubject, rhs: ApiSubject) -> Bool {
    if lhs.title == rhs.title &&
        lhs.subTitle == rhs.subTitle {
            return true
    }
    return false
}

public func != (lhs: ApiSubject, rhs: ApiSubject) -> Bool {
    if lhs.subjectId != rhs.subjectId {
        return true
    }
    return false
}

public final class ApiSubject : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var subjectId : String!
    public var parentSubjectId : String?
    public var title : String = ""
    public var subTitle: String = ""
    public var imageName : String? = nil
    public var imageURL : String? = nil
    
    public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: Any] else { return nil }
		
        self.subjectId = representation["_id"] as! String
        self.title     = representation["name"] as! String
        self.subTitle  = representation["info"] as! String
        self.imageName = representation["iconName"] as? String
        self.imageURL  = representation["imageURL"] as? String
        
        let parentSubjectIdString = representation["parentSubjectId"] as? String
        if let parentSubjectId = parentSubjectIdString {
            self.parentSubjectId = parentSubjectId;
        }
    }
	
	public override init(){
	}
	
    public init(_subjectId: String, _title: String, _subTitle: String, _imageURL: String) {
        self.subjectId = _subjectId
        self.title     = _title
        self.subTitle  = _subTitle
        self.imageURL = _imageURL
    }
    
    public init(_parentSubjectId: String, _subjectId: String, _title: String, _subTitle: String, _imageName: String) {
        self.parentSubjectId = _parentSubjectId
        self.subjectId = _subjectId
        self.title     = _title
        self.subTitle  = _subTitle
        self.imageName = _imageName
    }
    
    public init(_parentSubjectId: String, _subjectId: String,  _title: String) {
        self.parentSubjectId = _parentSubjectId
        self.subjectId = _subjectId
        self.title     = _title
    }
    
    public func toJson()-> String{
        var string = "{"
        
        string += " \"_id\" : \"" + subjectId + "\","
        string += " \"name\" : \"" + title + "\","
        string += " \"info\" : \"" + subTitle + "\","
        if(imageName != nil){
            string += " \"iconName\" : \"" + imageName! + "\","
        }
        if(imageURL != nil){
            string += " \"iconName\" : \"" + imageURL! + "\","
        }
        if(parentSubjectId != nil){
            string += " \"parentSubjectId\" : \"" + parentSubjectId! + "\","
        }
        
        string = String(string.characters.dropLast())
        string += "}"
        
        return string
    }
}
