//
//  IPaymentService.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 4/14/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IPaymentService {
	func getClientToken(  completion: @escaping ( _ success: Bool,  _ token: String?)-> Void)
}
