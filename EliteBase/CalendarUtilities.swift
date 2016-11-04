//
//  CalendarUtilities.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/15/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

open class CalendarUtilities {
	open static func dayIntToString(_ day: Int) -> String{
		switch day {
		case 1:
			return "Sunday"
		case 2:
			return "Monday"
		case 3:
			return "Tuesday"
		case 4:
			return "Wednesday"
		case 5:
			return "Thursday"
		case 6:
			return "Friday"
		case 7:
			return "Saturday"
		default:
			return "Error"
		}
	}
    
    open static func convertSecondsToMilliseconds(_ seconds: TimeInterval) -> TimeInterval {
        return seconds * 1000.0
    }
    
	open static func stringToNSDate(_ dateString: String?) -> Date? {
		if(dateString == nil){
			return nil
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		dateFormatter.timeZone = TimeZone(identifier: "UTC")
		let returnDate = dateFormatter.date(from: dateString!)
		return returnDate
	}
}
