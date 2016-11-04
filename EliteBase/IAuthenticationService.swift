//
//  IAuthenticationService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData

public protocol IAuthenticationService {

	func savePassword(_ newPassword : String)
    func logout(_ deviceToken: String)
	func getUserLoginData(_ completion: @escaping(_ success: Bool, _ loginData: UserLoginData?)-> Void)
	func login(_ email: String, password: String) -> Promise<UserLoginData>
}
