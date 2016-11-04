//
//  RecentTutorService.swift
//  EliteBase
//
//  Created by Jonathan Lu on 8/8/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

open class RecentTutorService : IRecentTutorService {
    
    fileprivate var authService : IAuthenticationService
    
    public init(authService : IAuthenticationService){
        self.authService = authService
    }
    
    open func getRecentTutorsForUser(_ userId: String, completion: @escaping (_ success : Bool, _ notifications : [ApiRecentTutor]?) -> Void ){
        
        authService.getUserLoginData(){
            success, userLoginData in
            
            Alamofire.request(Router.getRecentTutors(userId,userLoginData!.token))
				.responseCollection { (response : DataResponse<[ApiRecentTutor]>) in
					if let tutors = response.result.value {
						completion(true, tutors)
						return
					}
					
					completion(true, nil);
            }
        }
    }
}
