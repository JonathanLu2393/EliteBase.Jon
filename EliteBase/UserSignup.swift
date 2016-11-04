//
//  UserSignup.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 10/21/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

public final class UserSignup {
	
	public var email : String! = ""
	public var password : String! = ""
	public var passwordConfirm : String! = ""
	public var mobileNumber : String! = ""
	
	public var creditCardNumber : String! = ""
	public var nameOnCard : String! = ""
	public var expirationMonth : Int! = 0
	public var expirationYear : Int! = 0
	public var cvv : String!
	public var paymentMethodNonce : String!
	
	public init(){}
	
	public func toJSONArray()-> [String: NSObject]{
		
		let fullNameArr = nameOnCard.components(separatedBy: " ")
		//let expirationDate = expirationMonth.description + "/" + expirationYear.description
		
		let customerData :[String : NSObject] = [
			"firstName" : fullNameArr[0] as NSObject,
			"lastName" : fullNameArr[1] as NSObject,
			"email" : email as NSObject,
			"password" : password as NSObject,
			"phone": mobileNumber as NSObject,
			"paymentMethodNonce" : paymentMethodNonce as NSObject
			
		]
		return customerData
	}
}
