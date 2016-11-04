//
//  ISessionService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol ISessionService {
	func startSession(_ bookingId : String, completion: @escaping (_ success: Bool, _ session: ApiSession?)-> Void)
	func getSession(_ sessionId : String, completion: @escaping (_ success: Bool, _ session: ApiSession?)->Void)
	func endSession(_ sessionId: String, completion: @escaping (_ success: Bool, _ session: ApiSession?)-> Void)
}
