//
//  CoreDataTutorAuthDetailsMapper.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/3/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import CoreData

class CoreDataTutorAuthDetailsMapper {
	
	func map(_ managed: NSManagedObject)-> TutorAuthDetails{
		
		let tutorId = managed.value(forKey: "id") as! String
		let date     = managed.value(forKey: "date") as! Date
		
		let retVal = TutorAuthDetails()
		retVal.tutorId = tutorId
		retVal.date = date

		return retVal
	}
	
}
