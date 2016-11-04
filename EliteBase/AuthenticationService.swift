//
//  AuthenticationService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/13/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData
import PromiseKit

open class AuthenticationService : IAuthenticationService{
	
	fileprivate var managedObjectContext : NSManagedObjectContext;
	
	public init(managedObjectContext : NSManagedObjectContext){
		self.managedObjectContext = managedObjectContext
	}
	
	open func savePassword(_ newPassword : String) {
		if let savedUser = fetchUserFromCoreData() {
			let email = savedUser.email
			let token = savedUser.token
			let userId = savedUser.userId
			
			deleteSavedUser()
			saveUserToCoreData(email, password: newPassword, token: token, userId: userId)
		}
    }
    
    open func logout(_ deviceToken: String) {
        deleteDeviceToken(deviceToken)
        deleteSavedUser()
    }
	
	open func login(_ email: String, password: String) -> Promise<UserLoginData> {
		return Promise { fulfill, reject in
			requestNewToken(email, password: password){
				success, returnToken, userId, message in
				
				if(!success){
					reject(LoginError.loginFailed(message))
					return
				}
				self.deleteSavedUser()
				self.saveUserToCoreData(email, password: password, token: returnToken!, userId: userId!)
                
				let user = self.fetchUserFromCoreData()
				fulfill(user!)
			}
		}
	}
	
	open func getUserLoginData(_ completion: @escaping (_ success: Bool, _ loginData: UserLoginData?)-> Void) {
		
		let fetchedUser = fetchUserFromCoreData()
		
		if(isUserLoggedIn(fetchedUser)){
			completion(true, fetchedUser)
			return
		}
		
		if(fetchedUser == nil){
			completion(false, nil)
			return
		}
		//Get and save token
		let email = fetchedUser?.email
		let password = fetchedUser?.password
		
		requestNewToken(email!, password: password!) {
			success, returnToken, userId, message in
			if(success){
				self.deleteSavedUser()
				self.saveUserToCoreData(email!, password: password!, token: returnToken!, userId: userId!)
				completion(true, fetchedUser)
				return
			}
			
			completion(false, nil)
		}
	}
	
	fileprivate func isUserLoggedIn(_ user: UserLoginData?) -> Bool {

		if (user == nil) {
			return false
		}
		
		if(!user!.dateSaved.isInThePast()) {
			return true
		}
		
		return false
	}
    
	fileprivate func requestNewToken(_ email : String, password: String, completion: @escaping (_ success: Bool, _ token: String?, _ userId : String?, _ message: String? ) -> Void) {
		
		do {
		let request = try Router.authenticate(email, password).asURLRequest()
		Network.MakeNetworkRequest(request, successHandler: { (jsonData : JSON) in
			
			let success = jsonData["success"].bool!
			let message = jsonData["message"].string!
			
			if(success) {
				let token = jsonData["token"].string
				let userId = jsonData["_id"].string
				
				self.deleteSavedUser()
				self.saveUserToCoreData(email, password: password, token: token!, userId: userId!)
				completion( true, token, userId, message)
				return
			}
			
			completion(false, nil,  nil, message)
			print("Token request failed with error: \(message)")
			
			}) { 
				completion(false, nil, nil, nil)
			}
		}
		catch let error as AFError {
			print("try/catch failed in requestNewToken: \(error)")
			completion(false, nil, nil, nil);
		}
		catch {
			print("try/catch failed in requestNewToken")
			completion(false, nil, nil, nil);
		}
    }
	
	
	fileprivate func saveUserToCoreData(_ email: String, password: String, token: String, userId: String) {
		
		let entity =  NSEntityDescription.entity(forEntityName: "User", in: self.managedObjectContext)
		let userObj = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
		
		userObj.setValue(email, forKey: "email")
		userObj.setValue(password, forKey: "password")
		userObj.setValue(token, forKey: "token")
		userObj.setValue(userId, forKey: "userId")
		
		let todayDate = Date().addHours(12)
		
		userObj.setValue(todayDate, forKey: "date")
		
		do {
			try self.managedObjectContext.save()
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
	
	fileprivate func deleteSavedUser() {
		let savedUser = fetchUserFromCoreData()
		guard let user = savedUser else {return}
		
		CoreDataUtilities.deleteObject(self.managedObjectContext, object: user.object)
	}
    
    fileprivate func deleteDeviceToken(_ deviceToken: String) {
        self.getUserLoginData(){
            success, userLoginData in
            
            if(!success){
                return
            }
            
            Alamofire.request(Router.deleteDeviceToken(deviceToken, userLoginData!.token))
        }
    }
	
	fileprivate func fetchUserFromCoreData() -> UserLoginData? {
		
		let savedObject = CoreDataUtilities.fetchObject(self.managedObjectContext, entity: "User")
		
		if let obj = savedObject{
			 return UserLoginData(object: obj)
		}
		
		return nil
	}
}
