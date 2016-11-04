//
//  ICalendarService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import CoreLocation

public protocol ICalendarService {

	func getPlannerEventsForDay(_ day : Date, completion: @escaping(_ success : Bool, _ events : [PlannerEvent]?) -> Void)
	func getCalendarEventsForMonth(_ startDate : Date, endDate : Date, completion: @escaping(_ success : Bool, _ events: [ApiCalendarEvent]?)->Void )
	func getAvailabilitiesForMonth(_ tutorId : String, startDate : Date, endDate : Date, completion: @escaping(_ success : Bool, _ events: [ApiCalendarEvent]?)->Void )
    func getRegionAvailabilitiesForMonth(_ coordinates : CLLocationCoordinate2D, subjectId : String, startDate : Date, endDate : Date, completion: @escaping(_ success : Bool, _ days: [ApiRegionSubjectDay]?)->Void )
}
