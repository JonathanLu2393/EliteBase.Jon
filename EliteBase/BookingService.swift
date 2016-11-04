//
//  BookingService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/11/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class BookingService : IBookingService{

	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}
	
	open func getBookingDetailsStudent(_ bookingId : String, completion: @escaping (_ success : Bool, _ details : ApiBookingDetails?)-> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			do {
				let request = try Router.getBookingDetails(bookingId, userLoginData!.token).asURLRequest();
				Network.MakeNetworkRequestForObject(request, successHandler: { (data) in
					completion(true,  data);
				}, failureHandler: {
						completion( false,  nil);
				})
				
			} catch let error as AFError {
				print("try/catch failed in getAllBookings: \(error)")
				completion(false, nil)
			} catch {
				print("try/catch failed unhandled in getAllBookings: \(error)")
				completion(false, nil)
			}
		}
	}
	
	open func getBookingDetailsTutor(_ bookingId : String, completion: @escaping (_ success: Bool, _ details: ApiBookingDetails?)-> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, nil)
				return
			}
		
			Alamofire.request(Router.getBookingDetailsForTutor(bookingId, userLoginData!.token)).responseObject {
				(response: DataResponse<ApiBookingDetails>) in
				
				if let bookingDetails = response.result.value {
					completion( true, bookingDetails)
					return
				}
				completion(false, nil)
			}
		}
	}
    
    open func getBookingById(_ tutorId: String, completion: @escaping (_ success : Bool, _ booking : ApiBooking?) -> Void ){
        
        let returnBooking = ApiBooking()
        
        Alamofire.request(Router.getBookingById(tutorId))
            .responseJSON {
				(response : DataResponse) in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.result.value!)
                    
                    let bookingObject = jsonData["data"]
                    
                    returnBooking.bookingId = bookingObject["_id"].string
                    returnBooking.tutorId   = bookingObject["tutorId"].string
                    returnBooking.tutorFirstName = bookingObject["tutorFirstName"].string
                    returnBooking.tutorLastName  = bookingObject["tutorLastName"].string
                    returnBooking.tutorImageUrl  = bookingObject["tutorImageUrl"].string
                    
                    returnBooking.studentFirstName = bookingObject["studentFirstName"].string
                    returnBooking.studentLastName  = bookingObject["studentLastName"].string
                    returnBooking.customerUserId   = bookingObject["userId"].string
                    returnBooking.studentImageUrl  = bookingObject["studentImageUrl"].string
                    
                    let subjects = bookingObject["subjects"].array
                    var subjectArray = [ApiSubject]()
                    
                    subjectArray = subjects!.map({ sub -> ApiSubject in
                        let subject = ApiSubject()
                        subject.subjectId = sub["_id"].string
                        subject.parentSubjectId = sub["parentSubjectId"].string
                        subject.title = sub["name"].string!
                        subject.subTitle = sub["info"].string!
                        return subject
                    })
                    
                    returnBooking.subjects = subjectArray
                    
                    returnBooking.startTime = CalendarUtilities.stringToNSDate(bookingObject["startTime"].string)
                    returnBooking.endTime = CalendarUtilities.stringToNSDate(bookingObject["endTime"].string)
                    
                    returnBooking.enteredAddress = bookingObject["enteredAddress"].string
                    returnBooking.confirmedAddress = bookingObject["confirmedAddress"].string
                    
                    completion( true,  returnBooking)
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion( false, nil)
                }
        }
    }
    
	open func getNextTwoBookings(_ completion: @escaping (_ success : Bool, _ bookings : [ApiBooking]?) -> Void ){
		
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
				
				Alamofire.request(Router.getNextTwoBookings(details!.tutorId, userLoginData!.token))
					.responseCollection { (response: DataResponse<[ApiBooking]>) in
						completion(true, response.result.value)
				}
			}
		}
    }
    
	open func getAllBookings(_ startDate: Date, endDate: Date, completion: @escaping (_ success : Bool, _ bookings : [ApiBooking]?) -> Void ){
		
		
	
		
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
				
				let convertedStartDate = startDate.millisecondsSince1970()
				let convertedEndDate = endDate.millisecondsSince1970()
			
				do{
					let request = try Router.getAllBookings(details!.tutorId, convertedStartDate, convertedEndDate, userLoginData!.token).asURLRequest()
					
					Network.MakeNetworkRequestForCollection(request,
					successHandler: { (data) in
												completion(true, data)
											   },
					failureHandler: {
												completion(false, nil)
					});
				} catch let error as AFError {
					print("try/catch failed in getAllBookings: \(error)")
					completion(false, nil)
				} catch {
					print("try/catch failed unhandled in getAllBookings: \(error)")
					completion(false, nil)
				}
			}
		}
    }
	
    open func cancelBookingTutor(_ bookingId : String, cancelReason: String, completion: @escaping (_ success : Bool, _ message: String?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false, "Failed to authenticate")
				return
			}
		
			Alamofire.request(Router.cancelBookingTutor(bookingId, cancelReason, userLoginData!.token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					let messageResponse = jsonData["message"].string
					
					completion(successResponse, messageResponse)
					
					return;
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false, nil);
				}
			}
		}
	} //cancelBooking
	
    open func cancelBookingStudent(_ bookingId : String, cancelReason: String, completion: @escaping (_ success : Bool, _ message: String?)-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.cancelBooking(bookingId, cancelReason, userLoginData!.token)).responseJSON {
				(response: DataResponse) in
				switch response.result {
				case .success(let data):
					let jsonData = JSON(data)
					let successResponse = jsonData["success"].bool!
					let messageResponse = jsonData["message"].string
					
					completion(successResponse, messageResponse)
					
					return;
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false, nil);
				}
			}
		}
	}
	
	open func completeBooking(_ booking : BookingInProgress, completion: @escaping (_ success: Bool)-> Void) {
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.createBooking(booking, userLoginData!.token))
				.validate()
				.responseJSON {
					(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					
					let successResponse = jsonData["success"].bool!
					_ = jsonData["message"].string
					
					completion(successResponse)
					
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion(false)
				}
			}
		}
	}
	
	open func claimTimeTicket(_ booking : BookingInProgress, completion: @escaping (_ success: Bool, _ reason : String?) -> Void){
		
		authenticationService.getUserLoginData(){
			success, loginData in
			
			var token = "Guest token"
			if let loginData = loginData{
				token = loginData.token
			}
			
			Alamofire.request(Router.claimTimeTicket(token, booking.tutorId!, booking.desiredTimeTicketIds!)).responseJSON { (response: DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					let successResponse = jsonData["success"].bool!
					let messageResponse = jsonData["message"].string
					
					
					var claimedTimeTickets = [ApiTimeTicket]()
					
					if(successResponse) {
						
						let allTicketsData = jsonData["data"]
						
						for index in 0 ..< allTicketsData.count {
							
							let currentTimeticket = ApiTimeTicket()
							let startTime = CalendarUtilities.stringToNSDate(jsonData["data"][index]["startTime"].string!)
							let endTime   = CalendarUtilities.stringToNSDate(jsonData["data"][index]["endTime"].string!)
							let claimTime = CalendarUtilities.stringToNSDate(jsonData["data"][index]["claimedOn"].string!)
							
							currentTimeticket.pricePerHour = jsonData["data"][index]["pricePerHour"].int
							currentTimeticket.timeTicketId = jsonData["data"][index]["_id"].string
							currentTimeticket.startTime = startTime
							currentTimeticket.endTime   = endTime
							currentTimeticket.tutorId   = jsonData["data"][index]["tutorId"].string
							currentTimeticket.claimedOn = claimTime
							currentTimeticket.claimedByUserId = loginData?.userId
							claimedTimeTickets.append(currentTimeticket)
						}
						booking.claimedTimeTickets = claimedTimeTickets
						completion( true,  nil)
					}
					completion( false, messageResponse)
				case .failure(let error):
					print("Request failed with error: \(error)")
					completion( false,  nil)
				}
			}
		}
	}
	
	open func unlockTimeTicket(_ booking : BookingInProgress) {
		
		if((booking.tutorId) != nil) {
			
			let startDate = CalendarUtilities.convertSecondsToMilliseconds(booking.startTime!.timeIntervalSince1970)
			let endDate = CalendarUtilities.convertSecondsToMilliseconds(booking.endTime!.timeIntervalSince1970)
			
			authenticationService.getUserLoginData(){
				success, loginData in
				
				var token = "Guest token"
				if let loginData = loginData{
					token = loginData.token
				}
				
				Alamofire.request(Router.unlockTimeTicket(booking.tutorId!, startDate, endDate, token)).responseJSON {
					(response : DataResponse) in
					switch response.result {
					case .success:
						let jsonData = JSON(response.result.value)
						let successResponse = jsonData["success"].bool
						let messageResponse = jsonData["message"].string
						
						if(successResponse == true) {
							//time ticket unlocked
							print(messageResponse)
							//continue through the funnel
						}
						
						if(successResponse == false) {
							//cannot lock time ticket
							print(messageResponse)
						}
						
					case .failure(let error):
						print("Request failed with error: \(error)")
					}
				}
			}
		}
	}
	
	open func lockTimeTicket(_ booking : BookingInProgress) {
		
		let startDate = CalendarUtilities.convertSecondsToMilliseconds(booking.startTime!.timeIntervalSince1970)
		let endDate = CalendarUtilities.convertSecondsToMilliseconds(booking.endTime!.timeIntervalSince1970)
		
		authenticationService.getUserLoginData(){
			success, loginData in
			
			var token = "Guest token"
			if let loginData = loginData{
				token = loginData.token
			}
			
			Alamofire.request(Router.lockTimeTicket(booking.tutorId!, startDate, endDate, token)).responseJSON {
				(response : DataResponse) in
				switch response.result {
				case .success:
					let jsonData = JSON(response.result.value)
					let successResponse = jsonData["success"].bool
					let messageResponse = jsonData["message"].string
					
					if(successResponse == true) {
						print(messageResponse)
					}
					
					if(successResponse == false) {
						print(messageResponse)
					}
					
				case .failure(let error):
					print("Request failed with error: \(error)")
				}
			}
		}
	}
}
