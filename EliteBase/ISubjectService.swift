//
//  ISubjectService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol ISubjectService {
	func getMasterSubjects(_ liveOnly : Bool, completion: @escaping (_ success : Bool, _ subjects : [ApiSubject]?) -> Void )
	func getChildSubjects(_ masterSubjectId: String, liveOnly : Bool, completion: @escaping (_ success : Bool, _ subjects : [ApiSubject]?) -> Void)
}
