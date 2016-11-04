//
//  Router.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/13/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Alamofire
import SwiftyJSON

public enum Router: URLRequestConvertible {
    
	public static var baseURLString = ""
	
	case authenticate(String,String)
    case applyPromoCodeForUser(String, String)
	case cancelBooking(String, String, String)
	case cancelBookingTutor(String, String, String)
	case childSubjects(String)
    
	case claimTimeTicket(String, String, [String])
	case createBooking(BookingInProgress, String)
	case createImageSignature(String, String)
    case createImageSignatureForStudent(String, String)
	case createOneTimeTimetickets(String, String, Date, Date)
    
	case createRepeatTransaction(String, String, String)
	case createSchedule(schedule : ApiSchedule, tokenString : String)
	case createTransaction(String)
	case createUser(UserSignup)
    case deleteDeviceToken(String,String)
    
	case deleteSchedule(String, String)
	case deleteTimeticket(String, String)
	case deleteTimeticketsInRange(String, String, Date, Date)
    case endSession(String, String)
    case getAllBookings(String,Double,Double,String)
    
    case getBookingById(String)
	case getBookingDetails(String, String)
	case getBookingDetailsForTutor(String, String)
    case getAllCouponsForUser(String, String)
	case getChildSubjects(String, Bool)
	
    case getCreditCardInfo(String,String)
	case getMasterSubjects(Bool)
    case getNextTwoBookings(String,String)
	case getNotifications(String,String)
    case getRecentTutors(String,String)
	
    case getPaymentClientToken()
	case getPaymentDetails(String,String)
	case getSchedulesForTutor(String, String)
	case getSession(String, String)
	case getTimeticket(String, String)
	
    case getTutorAuthDetails(String)
	case getTutorDayPlannerEvents(String, String, Date, Date) /**/
	case getTutorDetailsWithAvailability(String, Date, Date, Int)
    case getTutorMonthlyAvailabilities(String, String, Date, Date, String)
	case getTutorMonthlyCalendar(String, String, Date, Date, String)
	
    case getTutorPaymentInfo(String, String)
	case getTutorQualifications(String, String)
	case getTutors(String, Date, Date, Double, Double, Int)
    case getRegionMonthlyAvailabilities(Double , Double , String, Date, Date)
	case getStudentAccountDetails(String, String)
	
    case getTutorAccountDetails(String, String) /**/
	case lockTimeTicket(String,TimeInterval,TimeInterval,String)
	case masterSubjects()
	case pollBlocks(String,String)
	case postRating(Rating,String)
	
    case readNotification(String,String) /**/
	case resetPassword(String)
	case startSession(String, String)
	case tutorById(String)
	case unlockTimeTicket(String,TimeInterval,TimeInterval,String)
    
    case updateCoordinates(String, Double, Double, Int, String) /**/
	case updateCreditCard(CreditCard,String)
    case updateDeviceToken(String, String)
    case updateTutorQualifications(String, String, [ApiTutorQualification])
	case updateTutorImageUrl(String, String, String)
	
    case updateTutorUser(ApiUserAccountDetails, String, String, String)
	case updateStudentUser(ApiUserAccountDetails, String, String)
	case updateUserImageUrl(String, String, String)
    case updateUserTimeZone(String, String, String)
	
	
	public func asURLRequest() throws -> URLRequest {
		var path : String! {
			switch self {
			
            case .authenticate:
				return "/authenticate"
            case .applyPromoCodeForUser(let promocode, _):
                return "/promocode/\(promocode)"
			case .cancelBooking(let bookingId, _, _):
				return "/booking/\(bookingId)/studentcancel"
			case .cancelBookingTutor(let bookingId, _, _):
				return "/booking/\(bookingId)/tutorcancel"
			case .childSubjects(let masterSubjectId):
				return "/subjects/children/\(masterSubjectId)"
			
            case .claimTimeTicket(_,_,_):
				return "/v2/timeticket/claim"
			case .createBooking(_, _):
				return "/booking"
			case .createImageSignature:
				return "/images/sign"
            case .createImageSignatureForStudent:
                return "/images/sign"
			case .createOneTimeTimetickets:
				return "/schedule/onetime"
			
            case .createRepeatTransaction(_,let transactionId,_):
				return "/payment/transaction/\(transactionId)/repeat"
			case .createSchedule:
				return ("/schedule")
			case .createTransaction(_):
				return "/payment/transaction"
			case .createUser( _):
				return "/user"
            case .deleteDeviceToken(_,_):
                return "user/deviceToken"
			
            case .deleteSchedule(_, let scheduleId):
				return "/schedule/\(scheduleId)"
			case .deleteTimeticket(_, let timeticketId):
				return "/timeticket/\(timeticketId)"
			case .deleteTimeticketsInRange:
				return "/timetickets/range"
			case .endSession(_, let sessionId):
				return "/session/\(sessionId)/end"
            case .getAllBookings(let tutorId,_,_,_):
                return "/tutor/\(tutorId)/bookings"
            
            case .getBookingById(_):
                return "/booking/"
			case .getBookingDetails(let bookingId, _):
				return "/booking/\(bookingId)/details"
			case .getBookingDetailsForTutor(let bookingId, _):
				return "/booking/\(bookingId)/tutorDetails"
            case .getAllCouponsForUser(let userId, _):
                return "/user/\(userId)/coupons"
			case .getChildSubjects(let masterSubjectId, _):
				return "/subjects/children/\(masterSubjectId)"
			
            case .getCreditCardInfo(_, _):
                return "/payment"
            case .getMasterSubjects(_):
				return "/subjects/master"
            case .getNextTwoBookings(let tutorId,_):
				return "/tutor/\(tutorId)/nexttwobookings"
			case .getNotifications(_, _):
				return "/notification"
            case .getRecentTutors(let userId,_):
                return "/user/\(userId)/recentTutors"
			
            case .getPaymentClientToken:
				return "/payment/client_token"
            case .getPaymentDetails(let userId, _):
				return "/payment/\(userId)" /**/
            case .getSchedulesForTutor:
				return "/schedule"
            case .getSession(_, let sessionId):
				return "/session/\(sessionId)"
			case .getTimeticket(_, let timeticketId):
				return "/timeticket/\(timeticketId)"
			
            case .getTutorAuthDetails(_):
				return "/user/tutor"
			case .getTutorDayPlannerEvents(_, let tutorId, _, _):
				return "/tutor/\(tutorId)/calendar/dayview" /**/
			case .getTutorDetailsWithAvailability(let tutorId, _, _, _):
				return "/tutor/\(tutorId)/availability"
            case .getTutorMonthlyAvailabilities(_, let tutorId, _, _, _):
                return "/tutor/\(tutorId)/calendar/rebook/"
			case .getTutorMonthlyCalendar(_, let tutorId, _, _, _):
				return "/tutor/\(tutorId)/calendar/"
			
            case .getTutorPaymentInfo(_, let tutorId):
				return "/tutor/\(tutorId)/paymentinfo"
			case .getTutorQualifications(_, let tutorId):
				return "/v2/tutor/\(tutorId)/qualifications"
			case .getTutors(_, _, _, _, _, _):
				return "/v2/tutors"
            case .getRegionMonthlyAvailabilities(_,_,_,_,_):
                return "/calendar/region/availability/"
			case .getStudentAccountDetails(let userId, _):
				return ("/user/\(userId)")
			
            case .getTutorAccountDetails(let tutorId, _):
				return "/user/tutor/\(tutorId)" /**/
			case .lockTimeTicket(_,_,_,_):
				return "/timeticket/lock"
			case .masterSubjects ():
				return "/subjects/master"
			case .postRating(_):
				return "/rating"
			case .pollBlocks(_,_):
				return "/blocks"
			
            case .readNotification(let notificationId,_):
				return "notification/\(notificationId)" /**/
            case .resetPassword(_):
                return "/forgotPassword"
			case .startSession:
				return "/session"
			case .tutorById(let tutorId):
				return ("/tutors/\(tutorId)")
			case .unlockTimeTicket(_,_,_,_):
				return "/timeticket/unlock"
            
            case .updateCoordinates(let tutorId,_,_,_,_):
                return "tutors/\(tutorId)/location" /**/
			case .updateCreditCard(_,_):
				return "/payment"
            case .updateDeviceToken(_,_):
                return "user/deviceToken"
            case .updateTutorQualifications(_, let tutorId, _):
                return "/tutors/\(tutorId)/qualifications"
            case .updateStudentUser:
                return "/user"
            
            case .updateTutorUser:
                return "/user/tutor"
            case .updateTutorImageUrl(_, let tutorId, _):
                return "/tutors/\(tutorId)/image"
            case .updateUserImageUrl(_, let userId, _):
                return "/user/\(userId)/image"
            case .updateUserTimeZone(_, let userId, _):
                return "/user/\(userId)/timezone"
            }
        }

		var parameters: [String: AnyObject] {
			switch self {
            case .getAllBookings(_, let startDate, let endDate, _):
                let params = ["startDate": startDate, "endDate" : endDate]
                return params as [String : AnyObject]
            case .getBookingById(let bookingId):
                return ["bookingId" : bookingId as AnyObject]
			case .getChildSubjects(_, let liveOnly):
				return ["liveOnly" : liveOnly as AnyObject]
			case .getCreditCardInfo(let userId, _):
				let params = ["userId" : "\(userId)"]
				return params as [String : AnyObject]
			case .getMasterSubjects(let liveOnly):
				return ["liveOnly" : liveOnly as AnyObject]
			case .getNotifications(let userId, _):
				let params = ["userId" : "\(userId)"]
				return params as [String : AnyObject]
            case .getRecentTutors(let userId, _):
                let params = ["userId" : "\(userId)"]
                return params as [String : AnyObject]
			case .getTutorDayPlannerEvents(_, _, let startTime, let endTime):
				let params = ["startTime": startTime.millisecondsSince1970() as AnyObject, "endTime" : endTime.millisecondsSince1970() as AnyObject]
				return params
			case .getTutorDetailsWithAvailability(_, let startTime, let endTime, let duration):
				return ["startTime": startTime.millisecondsSince1970() as AnyObject,
				        "endTime" : endTime.millisecondsSince1970() as AnyObject,
				        "duration" : duration as AnyObject]
            case .getTutorMonthlyAvailabilities(_, _, let startTime, let endTime, let timeZone):
                return ["startTime": startTime.millisecondsSince1970() as AnyObject,
                        "endTime" : endTime.millisecondsSince1970() as AnyObject,
                        "timeZone" : timeZone as AnyObject]
			case .getTutorMonthlyCalendar(_, _, let startTime, let endTime, let timeZone):
				return ["startTime": startTime.millisecondsSince1970() as AnyObject,
				        "endTime" : endTime.millisecondsSince1970() as AnyObject,
				        "timeZone" : timeZone as AnyObject]
			case .getTutors(let subjectIds, let startTime, let endTime, let longitude, let latitude, let duration):
				let params = ["subjectIds" : "\(subjectIds)" as AnyObject,
					"startTime" : "\(startTime.millisecondsSince1970())" as AnyObject,
					"endTime" : "\(endTime.millisecondsSince1970())" as AnyObject,
					"longitude" : "\(longitude)" as AnyObject,
					"latitude" : "\(latitude)" as AnyObject,
					"duration" : "\(duration)" as AnyObject]
				return params
            case .getRegionMonthlyAvailabilities(let latitude, let longitude, let subjectId, let startDate, let endDate):
                let params = ["subjectId" : subjectId as AnyObject,
                              "startDate" : "\(startDate.millisecondsSince1970())" as AnyObject,
					"endDate" : "\(endDate.millisecondsSince1970())" as AnyObject,
					"longitude" : "\(longitude)" as AnyObject,
					"latitude" : "\(latitude)" as AnyObject]
                return params
			case .getSchedulesForTutor(_, let tutorId):
				return ["tutorId" : tutorId as AnyObject]
			case .pollBlocks(let userId, _):
				let params = ["userId" : "\(userId)"]
				return params as [String : AnyObject]
			case .startSession(_, let bookingId):
				return ["bookingId" : bookingId as AnyObject]
			default:
				let params = [String: AnyObject]()
				return params
			}
		}
	
		var method :  HTTPMethod {
			switch self {
			case
			.authenticate,
            .applyPromoCodeForUser,
			.cancelBookingTutor,
			.createOneTimeTimetickets,
			.createImageSignature,
			.createImageSignatureForStudent,
			.createSchedule,
			.endSession,
			.startSession,
			.resetPassword:
				return .post
				
			case
			.createUser,
			.lockTimeTicket,
			.unlockTimeTicket,
			.claimTimeTicket,
			.createBooking,
			.postRating,
			.createTransaction,
			.createRepeatTransaction,
			.cancelBooking:
				return .post
				
			case
            .deleteDeviceToken,
			.deleteSchedule,
			.deleteTimeticket,
			.deleteTimeticketsInRange:
				return .delete
            case
			.updateTutorUser,
			.updateTutorImageUrl,
            .updateCoordinates,
            .updateCreditCard,
            .updateDeviceToken,
            .updateTutorQualifications,
            .updateStudentUser,
            .updateUserImageUrl,
            .updateUserTimeZone:
                return .put
			default:
				return .get
			}
		}
		
		var body : [String : AnyObject]?{
			switch self{
			case .authenticate(let email, let password):
				return ["email" : "\(email)" as AnyObject, "password" : "\(password)" as AnyObject]
            case .cancelBooking(_, let cancelReason, _):
                return ["cancelReason" : cancelReason as AnyObject]
            case .cancelBookingTutor(_, let cancelReason, _):
                return ["cancelReason" : cancelReason as AnyObject]
			case .claimTimeTicket(_, let tutorId, let timeticketIds):
				return ["tutorId" : "\(tutorId)" as AnyObject, "timeticketIds" : timeticketIds.joined(separator: ",") as AnyObject]
			case .createBooking(let booking, _):
				return booking.toDictionary()
			case .createUser(let userSignup):
				return userSignup.toJSONArray()
			case .createImageSignature(_, let tutorId):
				return ["tutorId" : tutorId as AnyObject]
            case .createImageSignatureForStudent(_, let userId):
                return ["userId" : userId as AnyObject]
			case .createOneTimeTimetickets(_, let tutorId, let startTime, let endTime):
				return ["tutorId" : tutorId as AnyObject, "startTime" : startTime.millisecondsSince1970() as AnyObject, "endTime" : endTime.millisecondsSince1970() as AnyObject]
			case .createRepeatTransaction(let bookingId, let transactionId, _):
				return ["sessionId" : "\(bookingId)" as AnyObject, "transactionId" : "\(transactionId)" as AnyObject]
			case .createSchedule(let schedule, _):
				return schedule.toJSONArray()
			case .createTransaction(let bookingId):
				return ["bookingId" : "\(bookingId)" as AnyObject]
            case .deleteDeviceToken(let deviceToken,_):
                return ["deviceToken" : "\(deviceToken)" as AnyObject]
			case .deleteTimeticketsInRange(_, let tutorId, let startTime, let endTime):
				return ["tutorId" : tutorId as AnyObject, "startTime" : startTime.millisecondsSince1970() as AnyObject, "endTime" : endTime.millisecondsSince1970() as AnyObject]
			case .lockTimeTicket(let tutorId, let startTime, let endTime, _):
				return ["tutorId" : "\(tutorId)" as AnyObject, "startTime" : startTime as AnyObject, "endTime" : endTime as AnyObject]
			case .postRating(let rating, _):
				return rating.toDictionary()
            case .resetPassword(let email):
                return ["email" : email as AnyObject]
			case .unlockTimeTicket(let tutorId, let startTime, let endTime, _):
				return ["tutorId" : "\(tutorId)" as AnyObject, "startTime" : startTime as AnyObject, "endTime" : endTime as AnyObject]
            case .updateCoordinates(_, let long, let lat, let travelRadius,_):
                return ["longitude" : long as AnyObject, "latitude" : lat as AnyObject, "travelRadius" : travelRadius as AnyObject]
			case .updateCreditCard(let creditCard, _):
				let dict = creditCard.toDictionary()
				return dict
            case .updateDeviceToken(let deviceToken, _):
                return ["deviceToken" : deviceToken as AnyObject]
            case .updateTutorQualifications(_, _, let qualifications):
				let qualDictionaires = qualifications.map({qual in qual.toDictionary()})
				return ["qualifications" : qualDictionaires as AnyObject]
			case .updateTutorUser(let user, let userId, let tutorId, _):
				return user.toDictionary(userId,tutorId: tutorId)
			case .updateStudentUser(let user, let userId, _):
				return user.toDictionary(userId, tutorId: nil)
			case .updateTutorImageUrl(_, _, let url):
				return ["url" : url as AnyObject]
            case .updateUserImageUrl(_, _, let url):
                return ["url" : url as AnyObject]
            case .updateUserTimeZone(let timezone, _, _):
                return ["timezone" : timezone as AnyObject]
			default:
				return nil
			}
		}
		
		var header : [String: String]?{
			switch self {
            case .applyPromoCodeForUser(_, let token):
                return ["x-access-token" : token]
			case .cancelBooking(_,_, let token):
				return ["x-access-token" : token]
			case .cancelBookingTutor(_,_, let token):
				return ["x-access-token" : token]
			case .claimTimeTicket(let token, _, _):
				return ["x-access-token" : token]
			case .createBooking(_, let token):
				return ["x-access-token" : token]
			case .createImageSignature(let token, _):
				return ["x-access-token" : token]
            case .createImageSignatureForStudent(let token, _):
                return ["x-access-token" : token]
			case .createOneTimeTimetickets(let tokenString, _, _, _):
				return ["x-access-token" : tokenString]
			case .createRepeatTransaction(_, _, let token):
				return ["x-access-token" : token]
			case .createSchedule(_, let tokenString):
				return ["x-access-token" : tokenString]
            case .deleteDeviceToken(_,let token):
                return ["x-access-token" : token]
			case .deleteSchedule(let token, _):
				return ["x-access-token" : token]
			case .deleteTimeticket(let token, _):
				return ["x-access-token" : token]
			case.deleteTimeticketsInRange(let token, _, _, _):
				return ["x-access-token" : token]
			case .endSession(let token, _):
				return ["x-access-token" : token]
            case .getAllBookings(_,_,_,let token):
                return ["x-access-token" : token]
			case .getBookingDetails(_, let token):
				return ["x-access-token" : token]
			case .getBookingDetailsForTutor(_, let token):
				return ["x-access-token" : token]
            case .getAllCouponsForUser(_, let token):
                return ["x-access-token" : token]
            case .getNextTwoBookings(_,let token):
                return ["x-access-token" : token]
			case .getNotifications(_, let token):
				return ["x-access-token" : token]
            case .getRecentTutors(_, let token):
                return ["x-access-token" : token]
			case .getPaymentDetails(_, let token):
				return ["x-access-token" : token]
			case .getSchedulesForTutor(let token, _):
				return ["x-access-token" : token]
			case .getSession(let token, _):
				return ["x-access-token" : token]
			case .getStudentAccountDetails(_, let token):
				return ["x-access-token" : token]
			case .getTimeticket(let token, _):
				return ["x-access-token" : token]
			case .getTutorAuthDetails(let tokenString):
				return ["x-access-token" : tokenString]
			case .getTutorDayPlannerEvents(let token, _, _, _):
				return ["x-access-token" : token]
            case .getTutorMonthlyAvailabilities(let token, _, _, _, _):
                return ["x-access-token" : token]
			case .getTutorMonthlyCalendar(let token, _, _, _, _):
				return ["x-access-token" : token]
			case .getTutorPaymentInfo(let token, _):
				return ["x-access-token" : token]
			case .getTutorQualifications(let token, _):
				return ["x-access-token" : token]
			case .getTutorAccountDetails(_, let token):
				return ["x-access-token" : token]
			case .lockTimeTicket(_, _, _, let token):
				return ["x-access-token" : token]
			case .pollBlocks(_, let token):
				return ["x-access-token" : token]
			case .postRating(_, let token):
				return ["x-access-token" : token]
			case .readNotification(_, let token):
				return ["x-access-token" : token]
			case .startSession(let token, _):
				return ["x-access-token" : token]
            case .updateCoordinates(_, _, _, _, let token):
                return ["x-access-token" : token]
            case .updateDeviceToken(_, let token):
                return ["x-access-token" : token]
            case .updateTutorQualifications(let token, _, _):
                return ["x-access-token" : token]
			case .updateTutorUser(_,_,_, let tokenString):
				return ["x-access-token" : tokenString]
			case .updateStudentUser(_, _, let token):
				return ["x-access-token" : token]
			case .updateTutorImageUrl(let token, _, _):
				return ["x-access-token" : token]
            case .updateUserImageUrl(let token, _, _):
                return ["x-access-token" : token]
            case .updateUserTimeZone(_, _, let token):
                return ["x-access-token" : token]
			default:
				return nil
			}
		}
		
		let url = try Router.baseURLString.asURL()
		
		let urlRequest = URLRequest(url: url.appendingPathComponent(path))
		
		var mutable : URLRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
		mutable.httpMethod = method.rawValue
	
		
		if let bodyParams = body{
			mutable.setValue("application/json", forHTTPHeaderField: "Content-Type")
			mutable.addJsonArrayToRequestBody(bodyParams)
		}
	
		if let headerParams = header{
			for param in headerParams{
				mutable.setValue(param.1, forHTTPHeaderField: param.0)
			}
		}
		
		return mutable
	}
}
