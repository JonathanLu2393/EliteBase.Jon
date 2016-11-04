//
//  NSManagedObjectMapper.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/4/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import CoreData

class NSManagedObjectMapper {
	
	static func getDate(_ input : [NSManagedObject]) -> Date {
		
		let subject = input[0]
		
		let savedDate = subject.value(forKey: "date") as! Date
		
		return savedDate
	}
	
}
