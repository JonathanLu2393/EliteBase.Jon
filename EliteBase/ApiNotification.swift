//
//  Notification.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 8/26/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

public final class ApiNotification : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var notificationId : String!
    public var notificationType : NotificationType!
    public var notificationText : String!
    public var notificationDate : Date!
    public var hasBeenRead : Bool!
    public var hasBeenReadDate: Date?
    public var notificationImageUrl : String?
	public var bookingDate : Date?
	public var tutorName : String?
	public var address : String?
	public var bookingId : String?
    
    public init?(response: HTTPURLResponse, representation: Any) {
        super.init()
		
		guard let representation = representation as? [String: Any] else {
			return nil
		}
		
        self.notificationId = representation["_id"] as! String
        self.notificationType = NotificationType(rawValue: (representation["notificationType"] as! Int))
		
        let notificationDate = representation["notificationDate"] as? String
        self.notificationDate = CalendarUtilities.stringToNSDate(notificationDate!)
        
        self.hasBeenRead = representation["hasBeenRead"] as? Bool
		
		let dateString = representation["hasBeenReadDate"] as? String
		
		if(dateString != nil){
			self.hasBeenReadDate = CalendarUtilities.stringToNSDate(dateString!)
		}

        self.notificationImageUrl = representation["notificationImageUrl"] as? String
		
		let bookingDateString = representation["bookingDate"] as? String
		if let dString = bookingDateString {
			self.bookingDate =  CalendarUtilities.stringToNSDate(dString)
		}
		
		self.address = representation["address"] as? String
		self.tutorName = representation["tutorName"] as? String
		self.bookingId = representation["bookingId"] as? String
		
		self.notificationText = getMessageForNotificationType
    }

	var getMessageForNotificationType : String {
		get {
			if(self.notificationType == NotificationType.bookingCreated) {
				guard let tutorName = self.tutorName else { return "" }
				var message = "You booked \(tutorName) on " + bookingDate!.toLongDateTimeString()
				
				if let add = self.address {
					message += " at " + add
				}
				return message
			}
			
			if(self.notificationType == NotificationType.bookingCancelledStudent) {
				guard let tutorName = self.tutorName else { return "" }
				let message = "You cancelled the booking with " + tutorName + " at " + bookingDate!.toLongDateTimeString()

				return message
			}
			
			if(self.notificationType == NotificationType.bookingCancelledTutor){
				
				guard let tutorName = self.tutorName else { return "" }
				
				let message = "\(tutorName) cancelled the booking with you on " + bookingDate!.toLongDateTimeString()
				return message
			}
			
			return ""
		}
	}
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [ApiNotification] {
        var notifications: [ApiNotification] = []
        
        if let representation = representation.value(forKeyPath: "data") as? [[String: AnyObject]] {
            for notificationRepresentation in representation {
                if let notification = ApiNotification(response: response, representation: notificationRepresentation as AnyObject) {
                    notifications.append(notification)
                }
            }
        }
        return notifications
    }
}
