//
//  ITutorService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData

public protocol ITutorService {
	func getTutorAuthDetailsPromise() -> Promise<TutorAuthDetails>
	func getTutorAuthDetails(_ completion : @escaping (_ success  : Bool, _ details : TutorAuthDetails?) -> Void)
	func getTutorPaymentInfo(_ completion: @escaping (_ success: Bool, _ tutorPaymentInfo: ApiTutorPaymentInfo?)-> Void)
	func getTutorDetails(_ tutorId: String, completion: @escaping (_ success : Bool, _ tutorDetail : ApiTutorDetails, _ tutorQualification : [ApiTutorQualification]) -> Void)
	func getTutorDetailsWithAvailability(_ tutorId : String, startDate : Date, endDate : Date, duration : Int, completion : @escaping (_ success: Bool, _ tutorDetails : ApiTutorDetailsWithAvailability?)-> Void)
	func getTutorQualifications(_ tutorId : String, completion: @escaping (_ success: Bool, _ qualifications: [ApiTutorQualification]?)-> Void)
	func searchForTutors(_ booking: BookingInProgress, completion: @escaping (_ success : Bool, _ tutors : [TutorSearchResult]?) -> Void)
	func updateTutorQualifications(_ tutorId : String, qualifications : [ApiTutorQualification], completion: @escaping (_ success : Bool)-> Void)
	func logout()
}
