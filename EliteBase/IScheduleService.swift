//
//  IScheduleService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IScheduleService {
	func createSchedule(_ schedule : ApiSchedule, completion: @escaping (_ success: Bool, _ schedule : ApiSchedule?)-> Void)
	func createOneTimeTimetickets(_ startDate : Date, endDate: Date, completion: @escaping (_ success: Bool)-> Void)
	func getSchedulesForTutor(_ completion: @escaping (_ success: Bool, _ schedules: [ApiSchedule]?)-> Void)
	func deleteSchedule(_ scheduleId : String, completion: @escaping (_ success: Bool)-> Void)
}
