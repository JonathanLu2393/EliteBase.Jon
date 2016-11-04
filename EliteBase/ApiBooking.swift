//
//  Booking.swift
//  Elite Instructor
//
//  Created by Jonathan Lu on 2/10/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

public final class ApiBooking:  NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var bookingId : String?
    public var tutorId : String?
    public var tutorFirstName : String?
    public var tutorLastName : String?
    public var tutorImageUrl : String?
    
    public var studentFirstName : String?
    public var studentLastName : String?
    public var customerUserId : String?
    public var studentImageUrl : String?
    
    public var subjects = [ApiSubject]()
    public var claimedTimeTickets : [ApiTimeTicket]?
    public var startTime : Date?
    public var endTime : Date?
    
    public var coordinate : CLLocationCoordinate2D?
    public var confirmedAddress : String?
    public var enteredAddress : String?

    public init?(response: HTTPURLResponse, representation: Any) {
        super.init()
		
		guard let representation = representation as? [String: Any] else { return nil }
		
        self.bookingId      = representation["_id"] as? String
        self.tutorId        = representation["tutorId"] as? String
        self.tutorFirstName = representation["tutorFirstName"] as? String
        self.tutorLastName  = representation["tutorLastName"] as? String
        self.tutorImageUrl  = representation["tutorImageUrl"] as? String
        
        self.studentFirstName = representation["studentFirstName"] as? String
        self.studentLastName  = representation["studentLastName"] as? String
        self.customerUserId   = representation["userId"] as? String
        self.studentImageUrl  = representation["studentImageUrl"] as? String
        
        let subjects = JSON(representation["subjects"]!)
        
        for x in 0 ..< subjects.count {
            let subject = ApiSubject()
            subject.subjectId = subjects[x]["_id"].string
            subject.parentSubjectId = subjects[x]["parentSubjectId"].string
            subject.title = subjects[x]["name"].string!
            subject.subTitle = subjects[x]["info"].string!
            self.subjects.append(subject)
        }
        
        var timeTickets = [ApiTimeTicket]()
        
        let timeTicketArray = JSON(representation["claimedTimeTickets"]!)
        
        for i in 0 ..< timeTicketArray.count {
            let timeTicket = ApiTimeTicket()
            timeTicket.timeTicketId = timeTicketArray[i]["_id"].string
            timeTicket.startTime    = CalendarUtilities.stringToNSDate(timeTicketArray[i]["startTime"].string)
            timeTicket.endTime      = CalendarUtilities.stringToNSDate(timeTicketArray[i]["endTime"].string)
            timeTicket.tutorId      = timeTicketArray[i]["tutorId"].string
			timeTicket.pricePerHour = timeTicketArray[i]["pricePerHour"].int
			
            timeTicket.claimed      = timeTicketArray[i]["claimed"].bool
            timeTicket.claimedByUserId = timeTicketArray[i]["claimedByUserId"].string
            timeTicket.locked       = timeTicketArray[i]["locked"].bool
            
            timeTicket.claimedOn    = CalendarUtilities.stringToNSDate(timeTicketArray[i]["claimedOn"].string)
            timeTicket.lockedOn     = CalendarUtilities.stringToNSDate(timeTicketArray[i]["lockedOn"].string)
            
            timeTickets.append(timeTicket)
        }

        let startDate  = representation["startTime"] as? String
        let endDate    = representation["endTime"] as? String
        self.startTime = CalendarUtilities.stringToNSDate(startDate)
        self.endTime   = CalendarUtilities.stringToNSDate(endDate)

        self.enteredAddress = representation["enteredAddress"] as? String
        self.confirmedAddress = representation["confirmedAddress"] as? String
    }
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [ApiBooking] {
        
        var bookings: [ApiBooking] = []
        
        if let representation = representation["data"] as? [[String: AnyObject]] {
            for bookingRepresentation in representation {
                if let booking = ApiBooking(response: response, representation: bookingRepresentation as AnyObject) {
                    bookings.append(booking)
                }
            }
        }
        return bookings
    }
    
    override init() {
        
    }
}
