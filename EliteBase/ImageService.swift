//
//  ImageService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/16/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class ImageService : IImageService {
	
	fileprivate var authenticationService : IAuthenticationService!
	fileprivate var tutorService : ITutorService!
	
	public init(authService: IAuthenticationService, tutorService: ITutorService){
		self.authenticationService = authService
		self.tutorService = tutorService
	}

	open func getImageSignature(_ completion: @escaping (_ success: Bool, _ signature: ApiImageSignature?)->Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
		
			if(!success){
				completion(false, nil)
				return
			}
		
			self.tutorService.getTutorAuthDetails(){
				success, details in
			
				if(details == nil){
					completion(false, nil)
					return
				}

				Alamofire.request(Router.createImageSignature(userLoginData!.token, details!.tutorId)).responseJSON {
					response in
					
					switch response.result {
					case .success:
						
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						
						if(!successResponse){
							completion(false, nil)
							return
						}
						let signatureData = jsonData["data"]
						if(signatureData == nil){
							completion(true, nil)
							return
						}
						
						let signature = ApiImageSignature()
						signature.signature = signatureData["signature"].string
						signature.public_id = signatureData["public_id"].string
						signature.timestamp = signatureData["timestamp"].double
						signature.api_key = signatureData["api_key"].string
						signature.cloud_name = signatureData["cloud_name"].string
						
						completion(true, signature)
						return
						
					case .failure(let error):
						print(error)
						completion(false, nil)
						return
					}
				}
			}
        }
	}// get image signature
    
    open func getImageSignatureForStudent(_ completion: @escaping (_ success: Bool, _ signature: ApiImageSignature?)->Void){
        
        authenticationService.getUserLoginData(){
            success, userLoginData in
            
            if(!success || userLoginData == nil){
                completion(false, nil)
                return
            }
            
            Alamofire.request(Router.createImageSignatureForStudent(userLoginData!.token, userLoginData!.userId)).responseJSON {
                response in
                
                switch response.result {
                case .success:
                    
                    let jsonData = JSON(response.result.value!)
                    let successResponse = jsonData["success"].bool!
                    
                    if(!successResponse){
                        completion(false, nil)
                        return
                    }
                    let signatureData = jsonData["data"]
                    if(signatureData == nil){
                        completion(true, nil)
                        return
                    }
                    
                    let signature = ApiImageSignature()
                    signature.signature = signatureData["signature"].string
                    signature.public_id = signatureData["public_id"].string
                    signature.timestamp = signatureData["timestamp"].double
                    signature.api_key = signatureData["api_key"].string
                    signature.cloud_name = signatureData["cloud_name"].string
                    
                    completion( true,  signature)
                    return
                    
                case .failure(let error):
                    print(error)
                    completion( false, nil)
                    return
                }
            }
        }
    }// get image signature

	open func UpdateTutorImage(_ url : String, completion: @escaping (_ success : Bool )-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			if(!success){
				completion(false)
				return
			}
		
			self.tutorService.getTutorAuthDetails(){
				success, details in
				
				if(details == nil){
					completion(false)
					return
				}
			
				Alamofire.request(Router.updateTutorImageUrl(userLoginData!.token, details!.tutorId, url))
					.validate()
					.responseJSON {
					response in
					switch response.result {
						
					case .success:
						let jsonData = JSON(response.result.value!)
						let successResponse = jsonData["success"].bool!
						completion(successResponse)
						return
						
					case .failure(let error):
						print(error)
						completion(false)
						return
					}
				}
			} //auth details
		}
	}//updateTutorImage
	
	
	open func updateUserImage(_ url : String, completion: @escaping (_ success : Bool )-> Void){
		
		authenticationService.getUserLoginData(){
			success, userLoginData in
			
			Alamofire.request(Router.updateUserImageUrl(userLoginData!.token, userLoginData!.userId, url)).validate()
                .responseJSON {
				response in
				switch response.result {
					
				case .success:
					let jsonData = JSON(response.result.value!)
					let successResponse = jsonData["success"].bool!
					completion(successResponse)
					return
					
				case .failure(let error):
					print(error)
					completion(false)
					return
				}
			}
		}
	}
	
	
	
}
