//
//  TransactionService.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 1/27/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire

open class TransactionService : ITransactionService{
	
	fileprivate var authService : IAuthenticationService
	
	public init(authService : IAuthenticationService){
		self.authService = authService
	}
    
	open func createRepeatTransaction(_ currentBlock: ApiBlock){
        
		authService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.createRepeatTransaction(currentBlock.bookingId!, currentBlock.transactionId!, userLoginData!.token))
		}
    }
}
