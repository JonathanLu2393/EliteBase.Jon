//
//  Event.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/31/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit

open class PlannerEvent: NSObject, NSCoding {
	open var title : String!
	open var start : Date!
	open var end : Date!
	open var displayDate : Date!
	
	open var backgroundColor : UIColor? {
		get {
            
            if let isCompleted = self.userInfo["complete"] as? Bool {
                if(isCompleted) {
                    return UIColor(red:0.19, green:0.80, blue:0.00, alpha:0.9)
                }
            }
            
			if(self.userInfo["BookingId"] != nil){
				return UIColor.eliteGray().withAlphaComponent(0.9)
			}
			
			return UIColor.eliteMediumRed().withAlphaComponent(0.9)
		}
	}
	open var textColor : UIColor? {
		get {
			return UIColor.white
		}
	}
	
	open var userInfo = [String : AnyObject]()
	
    public override init() {
        self.title = ""
        self.start = Date()
        self.end = Date()
        self.displayDate = Date()
    }
    
    init(title: String, start: Date, end: Date, displayDate: Date, userInfo: NSDictionary) {
        self.title = title
        self.start = start
        self.end = end
        self.displayDate = displayDate
        self.userInfo = userInfo as! [String : AnyObject]
    }
    
	open func durationInMinutes() -> Int {
		let hourMinuteComponents: NSCalendar.Unit = [.minute]
		let timeDifference = (Calendar.current as NSCalendar).components(
			hourMinuteComponents,
			from: start,
			to: end,
			options: [])

		let duration = timeDifference.minute
		
		if(duration! < 30){
			return 30
		}
		
		return duration!
	}
	
	open func minutesSinceMidnight() -> Int {
		
		let units : NSCalendar.Unit = [.hour, .minute]
		let components = (Calendar.current as NSCalendar).components(units, from: start)
		return 60 * components.hour! + components.minute!
	}
    
    // MARK: NSCoding
    
    required convenience public init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
            let start = decoder.decodeObject(forKey: "start") as? Date,
            let end = decoder.decodeObject(forKey: "end") as? Date,
            let displayDate = decoder.decodeObject(forKey: "display") as? Date,
            let userInfo = decoder.decodeObject(forKey: "userInfo") as? NSDictionary
            else { return nil }
        
        self.init(
            title: title,
            start: start,
            end: end,
            displayDate: displayDate,
            userInfo: userInfo
        )
    }
    
    open func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.start, forKey: "start")
        coder.encode(self.end, forKey: "end")
        coder.encode(self.displayDate, forKey: "displayDate")
        coder.encode(self.backgroundColor, forKey: "backgroundColor")
        coder.encode(self.textColor, forKey: "textColor")
        coder.encode(self.userInfo, forKey: "userInfo")
    }
}
