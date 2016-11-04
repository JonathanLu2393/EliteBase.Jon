//
//  AuthToken.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/13/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import CoreData

public final class AuthToken: NSObject {
	public var userId  : String?
	public var token   : String?
	public var message : String
	public var success : Bool
	
	override init() {
		userId = "0"
		token = "none"
		message = ""
		success = false
	}
}
