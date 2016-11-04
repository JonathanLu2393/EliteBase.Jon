//
//  IBookingService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation


public protocol IBookingService {
	func getBookingDetailsTutor(_ bookingId : String, completion: @escaping (_ success: Bool, _ details: ApiBookingDetails?)-> Void)
	func getBookingDetailsStudent(_ bookingId : String, completion: @escaping (_ success: Bool, _ details: ApiBookingDetails?)-> Void)
	
	func getNextTwoBookings(_ completion: @escaping (_ success : Bool, _ bookings : [ApiBooking]?) -> Void )
	func getAllBookings(_ startDate: Date, endDate: Date, completion: @escaping (_ success : Bool, _ bookings : [ApiBooking]?) -> Void )
    func cancelBookingTutor(_ bookingId : String, cancelReason: String, completion: @escaping (_ success : Bool, _ message: String?)-> Void)
	func cancelBookingStudent(_ bookingId : String, cancelReason: String, completion: @escaping (_ success : Bool, _ message: String?)-> Void)
	
	func lockTimeTicket(_ booking : BookingInProgress)
	func unlockTimeTicket(_ booking : BookingInProgress)
	func claimTimeTicket(_ booking : BookingInProgress, completion: @escaping (_ success: Bool, _ reason : String?) -> Void)
	func completeBooking(_ booking : BookingInProgress, completion: @escaping (_ success: Bool)->Void)
	
}
