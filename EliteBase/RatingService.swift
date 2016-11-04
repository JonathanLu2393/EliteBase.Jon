//
//  RatingService.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 12/29/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

open class RatingService : IRatingService {
	
	fileprivate var authService : IAuthenticationService
	
	public init(authService : IAuthenticationService){
		self.authService = authService
	}
    
	open func saveRating(_ rating : Rating) {
        
		authService.getUserLoginData(){
			succss, userLoginData in
			
			Alamofire.request(Router.postRating(rating, userLoginData!.token))
		}
    }
}
