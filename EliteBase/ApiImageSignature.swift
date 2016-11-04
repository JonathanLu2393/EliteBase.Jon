//
//  ImageSign.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/16/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiImageSignature {
	var signature : String?
	var public_id : String?
	var timestamp : Double?
	var api_key : String?
	var cloud_name : String?
	
	open func toDictionary()-> [String : String]{
		
		return ["signature" : signature!,
			"public_id" : public_id!,
			"timestamp" : timestamp!.string(0),
			"api_key" : api_key!,
			"cloud_name" : cloud_name! ]
	}
}
