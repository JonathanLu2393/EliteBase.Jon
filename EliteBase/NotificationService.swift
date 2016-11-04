//
//  NotificationService.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 8/26/15.
//  Copyright (c) 2015 Eric Heitmuller. All rights reserved.
//

import Alamofire

open class NotificationService : INotificationService {
	
	fileprivate var authService : IAuthenticationService

	public init(authService : IAuthenticationService){
		self.authService = authService
	}
	
	open func getNotificationsForUser(_ userId: String, completion: @escaping (_ success : Bool, _ notifications : [ApiNotification]?) -> Void ){
        
		authService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.getNotifications(userId,userLoginData!.token))
				.responseCollection { (response: DataResponse<[ApiNotification]>) in
					
					completion(true, response.result.value)
			}
		}
    }
	
	open func readNotification(_ notificationId : String) {
        
		authService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.readNotification(notificationId, userLoginData!.token))
		}
    }
}
