//
//  ApiRegionSubjectDay.swift
//  EliteBase
//
//  Created by Jonathan Lu on 9/28/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class ApiRegionSubjectDay {
    open var date : Date!
    open var hasAvailability : Bool = false
    
    public init(){
        self.date = Date()
        self.hasAvailability = true
    }
}
