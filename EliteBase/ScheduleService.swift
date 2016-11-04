//
//  ScheduleService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/1/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class ScheduleService : IScheduleService{
	
	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func createSchedule(_ schedule : ApiSchedule, completion: @escaping (_ success: Bool, _ schedule : ApiSchedule?)-> Void){
	
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
		
			Alamofire.request(Router.createSchedule(schedule: schedule, tokenString: userLoginData!.token))
				.validate()
				.responseJSON {
					(response : DataResponse) in
				switch response.result {
				case .success(let data):
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					let _ = jsonData["message"].string
					
					if(successResponse) {
						let newSchedule = ApiSchedule()
						//newSchedule.isActive jsonData["data"]["schedule"];
						completion( true,  newSchedule)
						return
						
					}
					
					completion( false, nil)
					
				case .failure( let error):
					print(error);
					completion( false, nil)
				}
			}
		}
	}
	
	open func createOneTimeTimetickets(_ startDate : Date, endDate: Date, completion: @escaping (_ success: Bool)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
		
			if(!success){
				completion(false)
				return
			}
		
			self.tutorService.getTutorAuthDetails(){
				success, details in
			
				if(details == nil){
					completion(false)
					return
				}
				
				Alamofire.request(Router.createOneTimeTimetickets(userLoginData!.token, details!.tutorId, startDate, endDate))
					.validate()
					.responseJSON {
						(response: DataResponse) in
					switch response.result {
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						if(successResponse){
							completion(true)
							return
						}
						completion(false)
						
						return;
						
					case .failure(let error):
						print(error)
						completion(false)
					}
				}
			}
		}
	} //creatOneTimeTimetickets
	
	open func getSchedulesForTutor(_ completion: @escaping (_ success: Bool, _ schedules: [ApiSchedule]?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, details in
				
				if(details == nil){
					completion(false, nil)
					return
				}
				
				Alamofire.request(Router.getSchedulesForTutor(userLoginData!.token, details!.tutorId))
					.validate()
					.responseJSON {
						(response : DataResponse) in
					
					switch response.result{
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						let _ = jsonData["message"].string
						
						if(!successResponse){
							completion(false, nil);
							return
						}
					
						let scheduleData = jsonData["data"]
						if(scheduleData == nil){
							completion( true, nil)
							return
						}
						
						var schedules = [ApiSchedule]()
						for i in 0 ..< scheduleData.count {
							let current = scheduleData[i]
						
							let schedule = ApiSchedule()
							schedule.scheduleId = current["_id"].string
							schedule.activeMonday = current["activeMonday"].bool ?? false
							schedule.activeTuesday = current["activeTuesday"].bool ?? false
							schedule.activeWednesday = current["activeWednesday"].bool ?? false
							schedule.activeThursday = current["activeThursday"].bool ?? false
							schedule.activeFriday = current["activeFriday"].bool ?? false
							schedule.activeSaturday = current["activeSaturday"].bool ?? false
							schedule.activeSunday = current["activeSunday"].bool ?? false
							
							schedule.startHour = current["startHour"].int ?? 0
							schedule.startMinute = current["startMinute"].int ?? 0
							schedule.endHour = current["endHour"].int ?? 0
							schedule.endMinute = current["endMinute"].int ?? 0
				
							schedule.timeZone = current["timeZone"].string ?? ""
							schedule.tutorId = current["tutorId"].string
							
							schedules.append(schedule)
						}
						
						completion(true, schedules);
						return;
						
					case .failure( let error):
						print(error)
						completion(false, nil);
						return
					}
				}
			}
		}
	}//getSchedulesForTutor
	
	open func deleteSchedule(_ scheduleId : String, completion: @escaping (_ success: Bool)-> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
	
			if(!success){
				completion(false);
				return
			}
	
			Alamofire.request(Router.deleteSchedule(userLoginData!.token, scheduleId))
				.validate()
				.responseJSON {
					(response : DataResponse) in
				
				switch response.result{
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					let _ = jsonData["message"].string
					
					completion(successResponse);
					return
				case .failure(let error):
					print(error)
					completion(false);
					return
				}
			}
		}
	}//deleteSchedule
}
