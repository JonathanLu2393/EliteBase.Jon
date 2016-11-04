//
//  UserLoginData.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/21/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import CoreData

open class UserLoginData{
	
	var object : NSManagedObject
	
	public init(object : NSManagedObject){
		self.object = object;
	}
	
	open var email : String {
		get {
			if let email = object.value(forKeyPath: "email"){
				return  email as! String
			}
			
			return ""
		}
	}
	
	open var password : String {
		get {
			if let pw = object.value(forKeyPath: "password"){
				return  pw as! String
			}
			
			return ""
		}
	}
	
	open var userId : String {
		get {
			if let uId = object.value(forKeyPath: "userId"){
				return  uId as! String
			}
			
			return ""
		}
	}
	
	open var token : String {
		get {
			if let token = object.value(forKeyPath: "token"){
				return  token as! String
			}
			
			return ""
		}
	}
	
	open var dateSaved : Date {
		get {
			if let savedDate = object.value(forKey: "date"){
				return savedDate as! Date
			}
		
			return Date()
		}
	}
	
	
	
}
