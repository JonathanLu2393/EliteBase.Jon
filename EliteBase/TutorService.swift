//
//  TutorService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/18/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData
import PromiseKit

open class TutorService : ITutorService{
	
	fileprivate var savedData = [NSManagedObject]()
	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var managedObjectContext : NSManagedObjectContext
	
	public init(authService: IAuthenticationService, managedObjectContext : NSManagedObjectContext){
		self.authenticationService = authService
		self.managedObjectContext = managedObjectContext
	}
	
	fileprivate func getTutorAuthDetailsFromApi(_ completion: @escaping (_ success: Bool, _ details : TutorAuthDetails?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
		
			Alamofire.request(Router.getTutorAuthDetails(userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
					case .success:
						let jsonData = JSON(response.result.value!)
						
						let success = jsonData["success"].bool!
						let dataDict = jsonData["data"].rawValue as? [String : AnyObject]
						
						if(success == true && dataDict != nil) {
							
							let tutorId = dataDict!["_id"] as! String
							let authDetails = TutorAuthDetails()
							authDetails.tutorId = tutorId;
							authDetails.date = Date()
							
							//save the detail to coredata
							completion(true, authDetails)
							return
						}
						
						if(success == true && dataDict == nil){
							completion( true, nil)
							return
						}
						
						completion( false, nil)
						return
					
					case .failure(let error):
						print("Request failed with error: \(error)")
						completion(false, nil)
						return
				}
			}
		}
	}
    
    fileprivate func requestTutorId() -> String{
        
        getTutorAuthDetailsFromCoreData()
        
        if (savedData.isEmpty) {
            print("Error: Not Logged In")
        }
        
        return (savedData[0].value(forKeyPath: "id") as? String)!
    }
	
	fileprivate func getTutorAuthDetailsFromCoreData(){
		if let array = CoreDataUtilities.fetch(self.managedObjectContext, entity: "Tutor") {
			savedData = array
		}
	}
	
	fileprivate func saveTutorAuthDetailsToCoreData(_ details: TutorAuthDetails){
		
		let entity =  NSEntityDescription.entity(forEntityName: "Tutor", in: self.managedObjectContext)
		let tutorAuthDetailsObj = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
		
		tutorAuthDetailsObj.setValue(details.tutorId, forKey: "id")
		let expirationDate = Date().addDays(1);
		
		tutorAuthDetailsObj.setValue(expirationDate, forKey: "date")
		
		do {
			try self.managedObjectContext.save()
			savedData.append(tutorAuthDetailsObj)
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
	
	fileprivate func deleteSavedTutorAuthDetails() {
		CoreDataUtilities.delete(self.managedObjectContext, array: savedData)
	}
	
	open func getTutorAuthDetailsPromise() -> Promise<TutorAuthDetails> {
		return Promise { fulfill, reject in
			getTutorAuthDetails(){
				success, tutorAuthDetails in
				if(!success){
					reject(LoginError.loginFailed(nil))
					return
				}
				if(tutorAuthDetails == nil){
					reject(LoginError.notATutorError())
					return
				}
				
				fulfill(tutorAuthDetails!)
			}
		}
	}
	
	open func getTutorAuthDetails(_ completion : @escaping (_ success  : Bool, _ details : TutorAuthDetails?) -> Void) {
		
		getTutorAuthDetailsFromCoreData()
		
		if (!savedData.isEmpty) {
			let mapper = CoreDataTutorAuthDetailsMapper()
			let details = mapper.map(savedData[0]);
			
			if(!details.date.isInThePast()){
				completion(true, details)
				return
			}
			
			deleteSavedTutorAuthDetails()
		}
		
		getTutorAuthDetailsFromApi() {
			success, details in
			
			if(!success){
				completion(false, nil)
				return
			}
			
			if let apiDetails = details{
				self.saveTutorAuthDetailsToCoreData(apiDetails)
			}
			
			completion(true, details)
			return
		}
	}//getTutorAuthDetails
	
	open func logout(){
		deleteSavedTutorAuthDetails()
	}
	
	open func getTutorPaymentInfo(_ completion: @escaping (_ success: Bool, _ tutorPaymentInfo: ApiTutorPaymentInfo?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
	
			self.getTutorAuthDetails(){
				success, details in
				
				if(details == nil){
					completion(false, nil)
				}
				
				Alamofire.request(Router.getTutorPaymentInfo(userLoginData!.token, details!.tutorId)).responseJSON {
					(response: DataResponse) in
					
					switch response.result{
					case .success:
						
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion(false, nil)
							return
						}
						let paymentInfoData = jsonData["data"]
						if(paymentInfoData == nil){
							completion(true, nil)
							return
						}
						
						let info = ApiTutorPaymentInfo()
						info.accountNumberLast4 = paymentInfoData["accountNumberLast4"].string
						info.descriptor = paymentInfoData["descriptor"].string
						info.destination = paymentInfoData["destination"].string
						info.email = paymentInfoData["email"].string
						info.mobilePhone = paymentInfoData["mobilePhone"].string
						info.routingNumber	= paymentInfoData["routingNumber"].string
						
						completion( true, info)
						
						return
					case .failure(let error):
						print(error)
						completion(false, nil)
						return 
					}
				}
			}
		}
	}
	
	open func getTutorDetails(_ tutorId: String, completion: @escaping (_ success : Bool, _ tutorDetail : ApiTutorDetails, _ tutorQualification : [ApiTutorQualification]) -> Void){
		
		let returnTutorDetails = ApiTutorDetails()
		var returnTutorQualifications = [ApiTutorQualification]()
		var index = 0
		
		Alamofire.request(Router.tutorById(tutorId))
			.responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success(let data):
					let jsonData = JSON(data)
					
					returnTutorDetails.tutorId      = jsonData["data"]["_id"].string
					returnTutorDetails.firstName    = jsonData["data"]["firstName"].string
					returnTutorDetails.lastName     = jsonData["data"]["lastName"].string
					returnTutorDetails.imageUrl     = jsonData["data"]["imageUrl"].string
					returnTutorDetails.hourlyRate   = jsonData["data"]["hourlyRate"].double
					returnTutorDetails.city         = jsonData["data"]["city"].string
					returnTutorDetails.state        = jsonData["data"]["state"].string
					returnTutorDetails.rating       = jsonData["data"]["rating"].float
					returnTutorDetails.travelRadius = jsonData["data"]["travelRadius"].int
					returnTutorDetails.numberOfRatings = jsonData["data"]["numberOfRatings"].int
					returnTutorDetails.education    = jsonData["data"]["education"].string
					returnTutorDetails.backgroundCheckPassed = jsonData["data"]["backgroundCheckPassed"].bool
					returnTutorDetails.languages    = jsonData["data"]["languages"].string
					returnTutorDetails.calculatedRate  = jsonData["data"]["calculatedRate"].double
					
					for _ in jsonData["data"]["qualifications"] {
						
						let subjectId = jsonData["data"]["qualifications"][index]["subjectId"].string!
						let parentSubjectId = jsonData["data"]["qualifications"][index]["parentSubjectId"].string
						let subjectName = jsonData["data"]["qualifications"][index]["subjectName"].string!
						let eliteVerified = jsonData["data"]["qualifications"][index]["eliteVerified"].bool!
						
						let tutorQual = ApiTutorQualification(subjectId: subjectId, parentSubjectId: parentSubjectId, subjectName: subjectName,
							eliteVerified: eliteVerified)
						
						returnTutorQualifications.append(tutorQual)
						index += 1
					}
					
					completion(true,  returnTutorDetails, returnTutorQualifications)
					
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false,  returnTutorDetails, returnTutorQualifications)
				}
		}
	}
	
	open func getTutorDetailsWithAvailability(_ tutorId : String, startDate : Date, endDate : Date, duration: Int, completion : @escaping (_ success: Bool, _ tutorDetails : ApiTutorDetailsWithAvailability?)-> Void) {
		
		Alamofire.request(Router.getTutorDetailsWithAvailability(tutorId, startDate, endDate, duration)).responseObject {
			(response : DataResponse<ApiTutorDetailsWithAvailability>) in
			
			switch response.result{
			case .success:
				let availability = response.result.value;
				completion( true, availability)
				
			case .failure(let error):
				print("Request failed with error: \(error)")
				completion( false, nil)
			}
		}
	}
	
	open func getTutorQualifications(_ tutorId : String, completion: @escaping (_ success: Bool, _ qualifications: [ApiTutorQualification]?)->Void){
	
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}

			self.getTutorAuthDetails(){
				success, details in
				
				if(details == nil){
					completion(false, nil)
				}
				
				Alamofire.request(Router.getTutorQualifications(userLoginData!.token, details!.tutorId))
					.validate()
					.responseJSON {
					(response : DataResponse) in
					
					switch( response.result){
					case .success:
						let jsonData = JSON(response.result.value!)
						
						var returnTutorQualifications = [ApiTutorQualification]()
						for element in jsonData["data"] {
							
							let subjectId = element.1["subjectId"].string!
							let parentSubjectId = element.1["parentSubjectId"].string
							let subjectName = element.1["subjectName"].string!
							let eliteVerified = element.1["eliteVerified"].bool!
							
							let tutorQual = ApiTutorQualification(subjectId: subjectId, parentSubjectId: parentSubjectId, subjectName: subjectName,
								eliteVerified: eliteVerified)
							
							returnTutorQualifications.append(tutorQual)
						}
						completion(true, returnTutorQualifications)
					case .failure(let error):
						print("Request failed with error: \(error)")
						completion(false, nil)
					}
				}
			}
		}
	}
	
	open func searchForTutors(_ booking: BookingInProgress, completion: @escaping (_ success : Bool, _ tutors : [TutorSearchResult]?) -> Void){
		
		//TODO: add currentBooking subjects to URLRequest
		let childSubjectId = booking.childSubject?.subjectId
		
		let start = booking.desiredDate!.atMidnight()
		let end = start.addDays(1)
		
		Alamofire.request(Router.getTutors(childSubjectId!, start, end!, Double(booking.coordinate!.longitude), Double(booking.coordinate!.latitude), booking.desiredDuration! ))
			.responseCollection {
				(response : DataResponse<[TutorSearchResult]>) in
				completion(true, response.result.value)
		}
	}
	
	open func updateTutorQualifications(_ tutorId : String, qualifications : [ApiTutorQualification], completion: @escaping (_ success : Bool)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false)
				return
			}
			
			Alamofire.request(Router.updateTutorQualifications(userLoginData!.token, tutorId, qualifications))
				.validate()
				.responseJSON {
					(response : DataResponse) in
					switch(response.result){
					case .success:
						completion( true)
					case .failure(let error):
						print("\(error)")
						completion(false)
					}
			}
		}
	}
}
