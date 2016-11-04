//
//  INotificationService.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 4/14/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol INotificationService {
	func getNotificationsForUser(_ userId: String, completion: @escaping (_ success : Bool, _ notifications : [ApiNotification]?) -> Void )
	func readNotification(_ notificationId : String)
}
