//
//  NotificationType.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 8/26/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

public enum NotificationType: Int {
    case appointmentReminder = 0
    case paymentFailed = 1
    case accountCredit = 2
    case eliteMessage = 3
    case reviewPosted = 4
	case bookingCreated = 5
	case bookingCancelledStudent = 6
	case bookingCancelledTutor = 7

    //TODO: this should be an extension method instead of a static
    public static func getNotificationTypeDescription(_ type: NotificationType) -> String{
        switch type {
        case .appointmentReminder:
            return "Reminder"
        case .paymentFailed:
            return "Payment Failure"
        case .accountCredit:
            return "Credit Applied"
        case .eliteMessage:
            return "Elite Notification"
        case .reviewPosted:
            return "Review Posted"
		case .bookingCreated:
			return "Booking Created"
		case .bookingCancelledStudent:
			return "Booking Cancelled"
		case .bookingCancelledTutor:
			return "Booking Cancelled"
        }
    }
}
