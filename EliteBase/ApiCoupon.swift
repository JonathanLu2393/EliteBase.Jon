//
//  ApiCoupon.swift
//  EliteBase
//
//  Created by Jonathan Lu on 10/28/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ApiCoupon : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var userId    : String?
    public var type      : String?
    public var amount    : Int?
    public var createdOn : Date?
    public var usedOn    : Date?
    public var voidedOn  : Date?
    public var expiresOn : Date?
    public var name      : String?

    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard let representation = representation as? [String: Any] else { return nil }
        
        self.userId  = representation["userId"] as? String
        self.type    = representation["type"] as? String
        self.amount  = representation["amount"] as? Int
        
        let createdOnDate = representation["createdOn"] as? String
        self.createdOn    = CalendarUtilities.stringToNSDate(createdOnDate)
        let usedOnDate    = representation["usedOn"] as? String
        self.usedOn       = CalendarUtilities.stringToNSDate(usedOnDate)
        let voidedOnDate  = representation["voidedOn"] as? String
        self.voidedOn     = CalendarUtilities.stringToNSDate(voidedOnDate)
        let expiresOnDate = representation["expiresOn"] as? String
        self.expiresOn    = CalendarUtilities.stringToNSDate(expiresOnDate)
        
        self.name = representation["name"] as? String
    }
    
    override init() {
        
    }
}
