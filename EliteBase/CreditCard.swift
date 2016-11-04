//
//  CreditCard.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 1/11/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public final class CreditCard {
    public var ccNumber : String!
    public var ccName : String!
    public var expirationMonth : Int!
    public var expirationYear : Int!
    public var cvv : Int!
	public var blockId : String?
    
    public var userId: String!
    public var paymentToken: String!
	
	public init(){}
	
    public func toDictionary() -> [String: AnyObject]{
        var dict = [String: AnyObject]()
		
        dict["ccNumber"]        = ccNumber as AnyObject?
        dict["nameOnCard"]      = ccName as AnyObject?
        dict["cvv"]             = cvv as AnyObject?
        dict["expirationDate"]  = "\(expirationMonth)/\(expirationYear)" as AnyObject?
        dict["userId"]          = userId! as AnyObject?
        dict["token"]           = paymentToken as AnyObject?
		dict["blockId"]			= blockId as AnyObject?
        
        return dict
    }
}
