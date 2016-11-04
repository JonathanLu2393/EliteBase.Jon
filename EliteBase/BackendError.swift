//
//  BackendError.swift
//  EliteBase
//
//  Created by Eric Heitmuller on 10/24/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation


enum BackendError: Error {
	case network(error: Error) // Capture any underlying Error from the URLSession API
	case dataSerialization(error: Error)
	case jsonSerialization(error: Error)
	case xmlSerialization(error: Error)
	case objectSerialization(reason: String)
}
