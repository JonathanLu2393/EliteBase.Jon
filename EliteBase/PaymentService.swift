//
//  PaymentService.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 3/7/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class PaymentService : IPaymentService {
	
	fileprivate var authService : IAuthenticationService
	
	public init(authService : IAuthenticationService){
		self.authService = authService
	}
	
	open func getClientToken(completion: @escaping (_ success: Bool, _ token: String?)-> Void){
		
        Alamofire.request(Router.getPaymentClientToken()).responseJSON {
			response in
			
			//if let json = {
			switch(response.result){
			case .success:
				
				let jsonData = JSON(response.result.value!)
				let token = jsonData["token"].string
					
				completion(true, token);
					
				return
			case .failure(let error):
				print(error)
				completion(false, nil)
				return
			}
        }
	}
}
