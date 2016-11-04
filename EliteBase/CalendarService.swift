//
//  CalendarService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreLocation

open class CalendarService : ICalendarService {
	
	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService: ITutorService!
	
	public init(authService : IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func getPlannerEventsForDay(_ day : Date, completion: @escaping (_ success : Bool, _ events : [PlannerEvent]?) -> Void) {
		//make request
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, tutorAuthDetails in
				
				if(!success){
					completion(false, nil)
					return
				}
				
				let startDate = day.atMidnight()
				let endDate = startDate.addDays(1)
				
				Alamofire.request(Router.getTutorDayPlannerEvents(userLoginData!.token, tutorAuthDetails!.tutorId, startDate, endDate!)).responseJSON {
					(response : DataResponse) in

					switch response.result {
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion(false,  nil)
							return
						}
						let eventsData = jsonData["data"]
						if(eventsData == nil){
							completion( true,  nil)
							return
						}
						
						var plannerEvents = [PlannerEvent]()
			
						for i in 0..<eventsData.count {
							let event = eventsData[i]
							let plannerEvent = PlannerEvent()
							plannerEvent.start = CalendarUtilities.stringToNSDate(event["start"].string!)
							plannerEvent.end =  CalendarUtilities.stringToNSDate(event["end"].string!)
							plannerEvent.title = event["title"].string!
							plannerEvent.userInfo = [:]
							if let userInfo = event["userInfo"].rawValue as? [String : AnyObject]{
								plannerEvent.userInfo = userInfo
                                
                                if let _ = userInfo["BookingId"] as? String {
                                    
                                    let studentFirstName = event["studentFirstName"].string
                                    let studentLastName  = event["studentLastName"].string
                                    plannerEvent.title = "Booked Session with " + studentFirstName! + " " + studentLastName!
                                }
							}
							
							plannerEvents.append(plannerEvent)
						}
						
						if(plannerEvents.count == 0){
							completion( true, plannerEvents)
							return
						}
						
						plannerEvents.sort(){
							return $0.start.isLessThanDate($1.start)
						}
						var survivingEvents = [PlannerEvent]()
						var currentlyRunningEvent : PlannerEvent = plannerEvents[0]
						
						for i in 1..<plannerEvents.count {
							if(currentlyRunningEvent.title == plannerEvents[i].title){
								if(plannerEvents[i].userInfo["TimeticketId"] != nil){
                                    if (i > 0 && plannerEvents[i-1].end == plannerEvents[i].start) {
                                        currentlyRunningEvent.end = plannerEvents[i].end
                                        continue
                                    } //we've run into another block of schedule
                                    survivingEvents.append(currentlyRunningEvent)
                                    currentlyRunningEvent = plannerEvents[i]
                                    continue
								} //we've run into a booking
                                survivingEvents.append(currentlyRunningEvent)
                                currentlyRunningEvent = plannerEvents[i]
                                continue
							}
                            survivingEvents.append(currentlyRunningEvent)
                            currentlyRunningEvent = plannerEvents[i]
							continue
						}
						survivingEvents.append(currentlyRunningEvent)
						
						completion( true, survivingEvents)
						return
						
					case .failure(let error):
						print(error);
						completion( false,  nil)
					}
				}
			}
		}
	} //get planner events for day
	
	open func getCalendarEventsForMonth(_ startDate : Date, endDate : Date, completion: @escaping (_ success : Bool, _ events: [ApiCalendarEvent]?)->Void ){
	
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
			
			self.tutorService.getTutorAuthDetails(){
				success, tutorAuthDetails in
				
				if(!success){
					completion(false, nil)
					return
				}
				
				let currentTimeZone = TimeZone.autoupdatingCurrent.identifier
				
				Alamofire.request(Router.getTutorMonthlyCalendar(userLoginData!.token, tutorAuthDetails!.tutorId, startDate, endDate, currentTimeZone)).responseJSON{
					(response : DataResponse) in
					switch response.result{
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion( false,  nil)
							return
						}
						let eventsData = jsonData["data"]
						if(eventsData == nil){
							completion( true, nil)
							return
						}
						
						var calendarEvents = [ApiCalendarEvent]()
						//create plannerevents from data
						for i in 0..<eventsData.count {
							let event = eventsData[i]
							let calendarEvent = ApiCalendarEvent()
							calendarEvent.startTime = CalendarUtilities.stringToNSDate(event["startTime"].string!)
							calendarEvent.endTime =  CalendarUtilities.stringToNSDate(event["endTime"].string!)
							calendarEvent.hasAvailability = event["hasAvailabilty"].bool!
							calendarEvent.hasBooking = event["hasBooking"].bool!
							calendarEvents.append(calendarEvent)
						}
						
						completion(true, calendarEvents)
						return

					case .failure(let error):
						print(error)
						completion(false, nil)
						return
						
					}//switch
				}// Alamofire request
			} //getTutorAuthDetails
		}
	}
    
    open func getAvailabilitiesForMonth(_ tutorId : String, startDate : Date, endDate : Date, completion: @escaping (_ success : Bool, _ events: [ApiCalendarEvent]?)->Void ){
        
        authenticationService.getUserLoginData(){
            success, userLoginData in
            
            if(!success){
                completion(false, nil)
                return
            }
            
            let currentTimeZone = TimeZone.autoupdatingCurrent.identifier
            
            Alamofire.request(Router.getTutorMonthlyAvailabilities(userLoginData!.token, tutorId, startDate, endDate, currentTimeZone)).responseJSON{
				(response: DataResponse) in
                switch response.result{
                case .success:
                    let jsonData = JSON(response.result.value!)
                    let successResponse = jsonData["success"].bool!
                    
                    if(!successResponse){
                        completion(false, nil)
                        return
                    }
                    
                    let eventsData = jsonData["data"].array
                    
                    if(eventsData == nil){
                        completion(true, nil)
                        return
                    }
                    
                    var calendarEvents = [ApiCalendarEvent]()
                    
                    calendarEvents = eventsData!.map({ event -> ApiCalendarEvent in
                        let calendarEvent = ApiCalendarEvent()
                        calendarEvent.startTime = CalendarUtilities.stringToNSDate(event["startTime"].string!)
                        calendarEvent.endTime =  CalendarUtilities.stringToNSDate(event["endTime"].string!)
                        calendarEvent.hasAvailability = event["hasAvailabilty"].bool!
                        calendarEvent.hasBooking = false
                        return calendarEvent
                    })
                    
                    completion(true, calendarEvents)
                    return
                    
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                    return
                    
                }//switch
            }// Alamofire request
        }
    }
    
    open func getRegionAvailabilitiesForMonth(_ coordinates : CLLocationCoordinate2D, subjectId : String, startDate : Date, endDate : Date, completion: @escaping (_ success : Bool, _ days: [ApiRegionSubjectDay]?)->Void ){
        
        Alamofire.request(Router.getRegionMonthlyAvailabilities(coordinates.latitude, coordinates.longitude, subjectId, startDate, endDate)).responseJSON{
			(response: DataResponse) in
            switch response.result{
            case .success:
                let jsonData = JSON(response.result.value!)
                let successResponse = jsonData["success"].bool!
                
                if(!successResponse){
                    completion(false, nil)
                    return
                }
                    
                let regionSubjectDayData = jsonData["data"].array
                
                if(regionSubjectDayData == nil){
                    completion(true, nil)
                    return
                }
                    
                var regionSubjectDays = [ApiRegionSubjectDay]()
                
                regionSubjectDays = regionSubjectDayData!.map({ day -> ApiRegionSubjectDay in
                    let regionSubjectDay = ApiRegionSubjectDay()
                    regionSubjectDay.date = CalendarUtilities.stringToNSDate(day["date"].string!)
                    regionSubjectDay.hasAvailability = day["hasAvailability"].bool!
                    return regionSubjectDay
                })
                    
                completion(true, regionSubjectDays)
                return
                    
            case .failure(let error):
                print(error)
                completion(false, nil)
                return
                    
            }//switch
        }// Alamofire request
    }
}
