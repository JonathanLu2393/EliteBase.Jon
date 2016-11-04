//
//  Network.swift
//  EliteBase
//
//  Created by Eric Heitmuller on 10/26/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class Network {
	
	public static func MakeNetworkRequest(_ urlRequest : URLRequest, successHandler : @escaping (JSON)-> Void, failureHandler: @escaping ()-> Void) -> Void{
		
		Alamofire.request(urlRequest).responseJSON {
			(response : DataResponse) in
			switch(response.result){
			case .success:
				let jsonData = JSON(response.result.value!)
				successHandler(jsonData)
				return
			case .failure(let error):
				print("Error making request: \(error)")
				failureHandler()
				return
			}
		}
	}
	
	public static func MakeNetworkRequestForObject<T: ResponseObjectSerializable> (_ urlRequest : URLRequest, successHandler : @escaping (T?) -> Void, failureHandler: @escaping ()-> Void ) -> Void {
		
		Alamofire.request(urlRequest).responseObject {
			(response: DataResponse<T>) in
			switch(response.result){
			case .success:
				successHandler(response.result.value)
				return
			case .failure(let error):
				print("Error making collection request: \(error)")
				failureHandler()
				return
			}
		}
		
	}
	
	public static func MakeNetworkRequestForCollection<T: ResponseCollectionSerializable>(_ urlRequest : URLRequest, successHandler : @escaping ([T]?) -> Void, failureHandler: @escaping ()-> Void ) -> Void {
		Alamofire.request(urlRequest).responseCollection {
			(response: DataResponse<[T]>) in
			
			switch(response.result){
			case .success:
				successHandler(response.result.value)
				return
			case .failure(let error):
				print("Error making collection request: \(error)")
				failureHandler()
				return
			}
			
		}
	}
}
