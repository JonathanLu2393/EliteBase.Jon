//
//  LoginErrors.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 4/17/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Foundation.NSError

public enum LoginError : Error {
	case loginFailed(String?)
	case notATutorError()
}
