//
//  IUserService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IUserService {
	
	func getCreditCardInfo(_ completion: @escaping (_ success: Bool, _ message: String?, _ cardType: String?, _ imageURL: String?) -> Void)
	func getPaymentDetails(_ completion: @escaping (_ success : Bool, _ message: String?, _ paymentDetails : ApiUserPaymentDetails?) -> Void)
	func getTutorAccountDetails(_ completion: @escaping (_ success: Bool, _ message: String?, _ userAccountDetails : ApiUserAccountDetails?) -> Void)
	func getStudentAccountDetails(_ userId : String, completion: @escaping (_ success: Bool, _ message: String?, _ userAccountDetails : ApiUserAccountDetails?) -> Void)
	func registerUser(_ signupInfo: UserSignup, completion: @escaping (_ success : Bool, _ returnToken : AuthToken?)-> Void)
	func sendResetPasswordLink(_ email: String, completion: @escaping (_ success: Bool, _ message: String?) -> Void)
	func updateCoordinates(_ long: Double, lat: Double, travelRadius: Int, completion: @escaping (_ success: Bool) -> Void)
	func updatePaymentInfo(_ creditCard: CreditCard, completion: @escaping (_ success: Bool) -> Void)
	func updateTutorUser(_ user: ApiUserAccountDetails, tutorId: String, completion: @escaping (_ success: Bool) -> Void)
	func updateStudentUser(_ user: ApiUserAccountDetails, userId: String, completion: @escaping (_ success: Bool, _ message: String?) -> Void)
    func updateDeviceToken(_ deviceToken: String)
    func updateUserTimeZone(_ completion: @escaping (_ success: Bool) -> Void)
}
