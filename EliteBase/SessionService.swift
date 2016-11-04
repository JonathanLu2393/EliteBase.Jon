//
//  SessionService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/29/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class SessionService : ISessionService {

	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func startSession(_ bookingId : String, completion: @escaping (_ success: Bool, _ session: ApiSession?)-> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, details in
				
				if(!success || details == nil){
					completion(false, nil)
					return
				}
				
				Alamofire.request( Router.startSession(userLoginData!.token, bookingId)).responseJSON {
					(response : DataResponse) in
					switch response.result {
					case .success:
						
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion(false, nil)
							return
						}
						let sessionData = jsonData["data"]
						if(sessionData == nil){
							completion( true, nil)
							return
						}
						
						//TODO: Refactor to mapper
						let session	= ApiSession()
						session.bookingId = sessionData["bookingId"].string
						session.endTime = CalendarUtilities.stringToNSDate(sessionData["endTime"].string)
						session.finished = sessionData["finished"].bool ?? false
						session.scheduledEndTime = CalendarUtilities.stringToNSDate(sessionData["scheduledEndTime"].string)
						session.scheduledStartTime = CalendarUtilities.stringToNSDate(sessionData["scheduledStartTime"].string)
						session.startTime = CalendarUtilities.stringToNSDate(sessionData["startTime"].string)
						session.tutorId = sessionData["tutorId"].string
						session.userId = sessionData["userId"].string
						session.sessionId = sessionData["_id"].string
						
						completion( true,  session)
						return
					case.failure(let error):
						print(error)
						completion( false, nil)
						return
					}
				}
			}
		}
	}//startSession
	
	open func getSession(_ sessionId : String, completion: @escaping (_ success: Bool, _ session: ApiSession?)->Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil);
				return
			}
			
				
		Alamofire.request( Router.getSession(userLoginData!.token, sessionId)).responseJSON {
			(response : DataResponse) in
					
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					
					if(!successResponse){
						completion(false, nil)
						return
					}
					let sessionData = jsonData["data"]
					if(sessionData == nil){
						completion(true, nil)
						return
					}
					
					//TODO: Refactor to mapper
					let session	= ApiSession()
					session.bookingId = sessionData["bookingId"].string
					session.endTime = CalendarUtilities.stringToNSDate(sessionData["endTime"].string)
					session.finished = sessionData["finished"].bool ?? false
					session.scheduledEndTime = CalendarUtilities.stringToNSDate(sessionData["scheduledEndTime"].string)
					session.scheduledStartTime = CalendarUtilities.stringToNSDate(sessionData["scheduledStartTime"].string)
					session.startTime = CalendarUtilities.stringToNSDate(sessionData["startTime"].string)
					session.tutorId = sessionData["tutorId"].string
					session.userId = sessionData["userId"].string
					session.sessionId = sessionData["_id"].string
					
					completion(true, session)
					return
				case.failure( let error):
					print(error)
					completion(false, nil)
					return
				}
			
			}
		}
	} //getSession
	
	open func endSession(_ sessionId: String, completion: @escaping (_ success: Bool, _ session: ApiSession?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil);
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, details in
				
				if(!success || details == nil){
					completion(false, nil)
					return
				}
				
				Alamofire.request( Router.endSession(userLoginData!.token, sessionId)).responseJSON {
					(response : DataResponse) in
					
					switch response.result {
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion(false, nil)
							return
						}
						let sessionData = jsonData["data"]
						if(sessionData == nil){
							completion(true, nil)
							return
						}
						
						//TODO: Refactor to mapper
						let session	= ApiSession()
						session.bookingId = sessionData["bookingId"].string
						session.endTime = CalendarUtilities.stringToNSDate(sessionData["endTime"].string)
						session.finished = sessionData["finished"].bool ?? false
						session.scheduledEndTime = CalendarUtilities.stringToNSDate(sessionData["scheduledEndTime"].string)
						session.scheduledStartTime = CalendarUtilities.stringToNSDate(sessionData["scheduledStartTime"].string)
						session.startTime = CalendarUtilities.stringToNSDate(sessionData["startTime"].string)
						session.tutorId = sessionData["tutorId"].string
						session.userId = sessionData["userId"].string
						session.sessionId = sessionData["_id"].string
						
						completion(true, session)
						return
					case.failure(let error):
						print(error)
						completion(false, nil)
						return
					}
				}
			}
		}
	}
}
