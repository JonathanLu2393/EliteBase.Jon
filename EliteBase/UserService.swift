//
//  UserService.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/5/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

open class UserService : IUserService {
	
	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func getTutorAccountDetails(_ completion: @escaping (_ success: Bool, _ message: String?, _ userAccountDetails : ApiUserAccountDetails?) -> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, "Failed to Authenticate", nil)
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, details in
				
				if(!success || details == nil){
					completion(false, nil, nil)
					return
				}
				
				let returnUserDetails = ApiUserAccountDetails()
				
				Alamofire.request(Router.getTutorAccountDetails(details!.tutorId, userLoginData!.token))
					.responseJSON {
						(response : DataResponse) in
						switch response.result {
						case .success:
							let jsonData = JSON(response.result.value)
							
							let successResponse = jsonData["success"].bool
							let messageResponse = jsonData["message"].string
							
							if( successResponse == nil || successResponse! == false) {
								completion( false, messageResponse, nil)
								return
							}
							
							returnUserDetails.tutorId = jsonData["data"]["_id"].string
							returnUserDetails.firstName = jsonData["data"]["firstName"].string
							returnUserDetails.lastName = jsonData["data"]["lastName"].string
							returnUserDetails.email = jsonData["data"]["email"].string
							returnUserDetails.displayPassword = "******"
							returnUserDetails.actualPassword = userLoginData?.password
							returnUserDetails.phoneNumber = jsonData["data"]["phoneNumber"].string
							
							returnUserDetails.streetAddress = jsonData["data"]["streetAddress"].string
							returnUserDetails.city = jsonData["data"]["city"].string
							returnUserDetails.state = jsonData["data"]["state"].string
							returnUserDetails.zip = jsonData["data"]["zip"].string
							returnUserDetails.hourlyRate = jsonData["data"]["hourlyRate"].int
							returnUserDetails.travelRadius = jsonData["data"]["travelRadius"].int
							returnUserDetails.rating = jsonData["data"]["rating"].float
							returnUserDetails.numberOfRatings = jsonData["data"]["numberOfRatings"].int
							returnUserDetails.languages = jsonData["data"]["languages"].string
							returnUserDetails.imageUrl = jsonData["data"]["imageUrl"].string
							
							var tutorQualification = [ApiTutorQualification]()
							
							let subjects = jsonData["data"]["qualifications"]
							
							for x in 0 ..< subjects.count {
								
                                let qualificationSubject = ApiTutorQualification(subjectId: subjects[x]["subjectId"].string!, parentSubjectId: subjects[x]["parentSubjectId"].string, subjectName: subjects[x]["subjectName"].string!, eliteVerified: true)
								qualificationSubject.eliteVerified = subjects[x]["eliteVerified"].bool
								tutorQualification.append(qualificationSubject)
							}
							
							returnUserDetails.qualifications = tutorQualification
                            
                            returnUserDetails.hasLocation = (jsonData["data"]["location"] != nil)
							
							completion( successResponse!, messageResponse, returnUserDetails)
							
							
						case .failure(let error):
							print("Request failed with error: \(error)")
							completion(false,  nil, nil)
						}
				}
			}
		}
    }
	
	open func getStudentAccountDetails(_ userId : String, completion: @escaping (_ success: Bool, _ message: String?, _ userAccountDetails : ApiUserAccountDetails?) -> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.getStudentAccountDetails(userId, userLoginData!.token))
				.responseJSON {
					(response : DataResponse) in
					switch response.result {
					case .success:
						let jsonData = JSON(response.result.value)
						
						let successResponse = jsonData["success"].bool
						let messageResponse = jsonData["message"].string
						
						if((successResponse) != nil) {
							let returnUserDetails = ApiUserAccountDetails()
							returnUserDetails.firstName = jsonData["data"]["firstName"].string
							returnUserDetails.lastName = jsonData["data"]["lastName"].string
							returnUserDetails.email = jsonData["data"]["primaryemail"].string
							returnUserDetails.displayPassword = "******"
							returnUserDetails.actualPassword = userLoginData?.password
							returnUserDetails.yearOfBirth = jsonData["data"]["yearOfBirth"].int
							returnUserDetails.streetAddress = jsonData["data"]["streetAddress"].string
							returnUserDetails.city = jsonData["data"]["city"].string
							returnUserDetails.state = jsonData["data"]["state"].string
							returnUserDetails.zip = jsonData["data"]["zip"].string
							returnUserDetails.imageUrl = jsonData["data"]["imageUrl"].string
							returnUserDetails.phoneNumber = jsonData["data"]["phoneNumber"].string
							
							completion( successResponse!,  messageResponse,  returnUserDetails)
							return
						}
						completion(successResponse!,  messageResponse,  nil)
						
					case .failure(let error):
						print("Request failed with error: \(error)")
						completion(false, nil,  nil)
					}
			}
		}
	}
	
	open func updateTutorUser(_ user: ApiUserAccountDetails, tutorId: String, completion: @escaping (_ success: Bool) -> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false)
				return
			}
			
			Alamofire.request(Router.updateTutorUser(user, userLoginData!.userId, tutorId, userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					completion(true)
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false)
				}
			}
		}
    }
	
	open func updateCoordinates(_ long: Double, lat: Double, travelRadius: Int, completion: @escaping (_ success: Bool) -> Void) {
		
		tutorService.getTutorAuthDetails(){
			success, tutorAuth in
			
			if(!success){
				completion(false)
				return
			}
            
            self.authenticationService.getUserLoginData(){
                success, userLoginData in
                
                if(!success){
                    completion(false)
                    return
                }
		
                Alamofire.request(Router.updateCoordinates(tutorAuth!.tutorId, long, lat, travelRadius, userLoginData!.token))
        
                completion(true)
            }
		}
    }
    
    
    open func sendResetPasswordLink(_ email: String, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {
        Alamofire.request(Router.resetPassword(email)).responseJSON {
			(response : DataResponse) in
				
            switch response.result {
            case .success:
                let jsonData = JSON(response.result.value)
                let successResponse = jsonData["success"].bool
                let messageResponse = jsonData["message"].string
                
                if(successResponse == true) {
                    completion(successResponse!, messageResponse)
                    return
                }
                completion(successResponse!, messageResponse)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(false, nil)
            }
        }
    }
	
	open func registerUser(_ signupInfo: UserSignup, completion: @escaping (_ success : Bool, _ returnToken : AuthToken?)-> Void){
		
		let request = Router.createUser(signupInfo)
		
		Alamofire.request(request).responseJSON {
			(response : DataResponse) in
			switch response.result {
			case .success:
				let jsonData = JSON(response.result.value)
				let token = AuthToken()
				
				//Save the data to the token struct
				token.success = jsonData["success"].bool!
				token.message = jsonData["message"].string!
				token.token   = jsonData["token"].string
				
				if(token.success) {
					//return the token filled with required data
					completion(true, token)
					return
				}
				completion(false, token)
				
			case .failure(let error):
				print("Request failed with error: \(error)")
				completion(false, nil)
			}
		}
	}
	
	
	open func getPaymentDetails(_ completion: @escaping (_ success : Bool, _ message: String?, _ paymentDetails : ApiUserPaymentDetails?) -> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.getPaymentDetails(userLoginData!.userId, userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					let successResponse = jsonData["success"].bool
					let messageResponse = jsonData["message"].string
					
					if(successResponse == true) {
						
						let userId            = jsonData["data"]["userId"].string
						let paymentCustomerId = jsonData["data"]["paymentCustomerId"].string
						let paymentToken      = jsonData["data"]["paymentToken"].string
						let last4Digits       = jsonData["data"]["last4Digits"].string
						
						let returnPaymentDetails = ApiUserPaymentDetails()
						
						returnPaymentDetails.userId = userId
						returnPaymentDetails.paymentCustomerId = paymentCustomerId
						returnPaymentDetails.paymentToken = paymentToken
						returnPaymentDetails.last4Digits = last4Digits
						
						completion(true, messageResponse, returnPaymentDetails)
						return
					}
					completion(false, messageResponse, nil)
					
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false, nil, nil)
				}
			}
		}
	}
	
	open func updatePaymentInfo(_ creditCard: CreditCard, completion: @escaping (_ success: Bool) -> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.updateCreditCard(creditCard, userLoginData!.token))
				.validate()
				.responseJSON {
					(response : DataResponse) in
					switch response.result {
					case .success:
						completion(true)
						
					case .failure(let error):
						print("Request failed with error: \(error)")
						completion(false)
				}
			}
		}
	}
	
	open func getCreditCardInfo(_ completion: @escaping (_ success: Bool, _ message: String?, _ cardType: String?, _ imageURL: String?) -> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.getCreditCardInfo(userLoginData!.userId, userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					let successResponse = jsonData["success"].bool
					let messageResponse = jsonData["message"].string
					
					if(successResponse == true) {
						completion( successResponse!, messageResponse, jsonData["data"]["cardType"].string!, jsonData["data"]["imageUrl"].string!)
						return
					}
					completion(successResponse!, messageResponse, nil, nil)
					
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false,  nil,  nil,  nil)
				}
			}
		}
	}
	
	open func updateStudentUser(_ user: ApiUserAccountDetails, userId: String, completion:@escaping (_ success: Bool, _ message: String?) -> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			
			Alamofire.request(Router.updateStudentUser(user, userId, userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					let successResponse = jsonData["success"].bool
					let messageResponse = jsonData["message"].string
					
					if(successResponse == true) {
						completion(successResponse!, messageResponse)
						return
					}
					completion(false, messageResponse)
					
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false, nil)
				}
			}
		}
	}
	
    open func updateDeviceToken(_ deviceToken: String) {
        
        if(deviceToken == "") {
            return
        }
        
        authenticationService.getUserLoginData(){
            success, userLoginData in
            
            if(!success){
                return
            }
            
            Alamofire.request(Router.updateDeviceToken(deviceToken, userLoginData!.token))
        }
    }

    open func updateUserTimeZone(_ completion:@escaping (_ success: Bool) -> Void) {
        let currentTimeZone = TimeZone.autoupdatingCurrent
        
        authenticationService.getUserLoginData(){
            success, userLoginData in
            
            if (!success || userLoginData == nil) {
                completion(false)
                return
            }
            
            Alamofire.request(Router.updateUserTimeZone(currentTimeZone.identifier, userLoginData!.userId, userLoginData!.token))
                .validate()
                .responseJSON {
					(response : DataResponse) in
                    switch response.result {
                    case .success:
                        completion(true)
                    
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        completion(false)
                    }
                }
        }
    }
}
