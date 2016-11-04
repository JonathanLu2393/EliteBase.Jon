//
//  TimeticketService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class TimeTicketService : ITimeticketService{

	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func getTimeTicket(_ timeticketId : String, completion : @escaping (_ success: Bool, _ timeticket: ApiTimeTicket?) -> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil);
				return
			}
			
			Alamofire.request(Router.getTimeticket(userLoginData!.token, timeticketId)).responseJSON {
				response in
				
				switch response.result{
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					
					if(!successResponse){
						completion( false, nil)
						return
					}
					let timeticketData = jsonData["data"]
					if(timeticketData == nil){
						completion(true,  nil)
						return
					}
					
					let ticket = ApiTimeTicket()
					ticket.claimed = timeticketData["claimed"].bool
					ticket.claimedOn = CalendarUtilities.stringToNSDate(timeticketData["claimedOn"].string)
					ticket.claimedByUserId = timeticketData["claimedByUserId"].string
					ticket.endTime = CalendarUtilities.stringToNSDate(timeticketData["endTime"].string);
					ticket.locked = timeticketData["locked"].bool
					ticket.lockedByUserId = timeticketData["lockedByUserId"].string
					ticket.lockedOn = CalendarUtilities.stringToNSDate(timeticketData["lockedOn"].string)
					ticket.startTime = CalendarUtilities.stringToNSDate(timeticketData["startTime"].string)
					ticket.timeTicketId = timeticketData["_id"].string
					ticket.tutorId = timeticketData["tutorId"].string
					
					completion(true, ticket);
					return;
					
				case .failure(let error):
					print(error)
					completion(false, nil)
					return
				}
			}
		}
	} //getTimeTicket
	
	
	open func deleteTimeTicket(_ timeticketId : String, completion: @escaping (_ success: Bool)->Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false)
				return
			}
		
			Alamofire.request(Router.deleteTimeticket(userLoginData!.token, timeticketId)).responseJSON {
				(response: DataResponse) in
				switch response.result{
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					let _ = jsonData["message"].string!
					if(!successResponse){
						completion( false)
						return
					}
					
					completion( true)
					return;
				case .failure( let error):
					print(error)
					completion(false)
					return;
				}
			}
		}
	}//deleteTimeTicket
	
	open func deleteTimeTicketsInRange(_ startTime : Date, endTime: Date, completion : @escaping (_ success: Bool)-> Void ){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false)
				return
			}
			self.tutorService.getTutorAuthDetails(){
				success, tutorAuthDetails in
				
				if(!success){
					completion(false);
					return;
				}
				
				Alamofire.request(Router.deleteTimeticketsInRange(userLoginData!.token, tutorAuthDetails!.tutorId, startTime, endTime)).responseJSON {
					(response: DataResponse) in
					switch response.result{
					
					case .success:
						let jsonData = JSON(response.result.value)
						let successResponse = jsonData["success"].bool!
						let _ = jsonData["message"].string!
						if(!successResponse){
							completion(false)
							return
						}
						
						completion(true)
						return;
					case .failure(let error):
						print(error)
						completion(false)
						return;
					}
				}
			}
		}
	}//deleteTimeTicketsInRange
}
