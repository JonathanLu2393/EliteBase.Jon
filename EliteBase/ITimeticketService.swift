//
//  ITimeticketService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol ITimeticketService {
	func getTimeTicket(_ timeticketId : String, completion : @escaping (_ success: Bool, _ timeticket: ApiTimeTicket?) -> Void)
	func deleteTimeTicket(_ timeticketId : String, completion: @escaping (_ success: Bool)->Void)
	func deleteTimeTicketsInRange(_ startTime : Date, endTime: Date, completion : @escaping (_ success: Bool)-> Void )
}
