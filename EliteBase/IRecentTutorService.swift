//
//  IRecentTutorService.swift
//  EliteBase
//
//  Created by Jonathan Lu on 8/8/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IRecentTutorService {
    func getRecentTutorsForUser(_ userId: String, completion: @escaping (_ success : Bool, _ notifications : [ApiRecentTutor]?) -> Void )
}
