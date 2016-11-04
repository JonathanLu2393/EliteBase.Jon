//
//  ResponseCollectionSerializable.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Alamofire

public protocol ResponseCollectionSerializable {
    static func collection(response: HTTPURLResponse, representation: Any) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
	public static func collection(response: HTTPURLResponse, representation: Any) -> [Self] {
		var collection: [Self] = []
		
		if let representation = representation as? [String: Any] {
			let data = representation["data"] as? [[String : Any]]
			if let data = data {
				for itemRepresentation in data {
					if let item = Self(response: response, representation: itemRepresentation) {
						collection.append(item)
					}
				}
			}
		}
		
		return collection
	}
}

extension DataRequest {
	@discardableResult
	func responseCollection<T: ResponseCollectionSerializable>(
		queue: DispatchQueue? = nil,
		completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
	{
		let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
			guard error == nil else { return .failure(BackendError.network(error: error!)) }
			
			let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
			let result = jsonSerializer.serializeResponse(request, response, data, nil)
			
			guard case let .success(jsonObject) = result else {
				return .failure(BackendError.jsonSerialization(error: result.error!))
			}
			
			guard let response = response else {
				let reason = "Response collection could not be serialized due to nil response."
				return .failure(BackendError.objectSerialization(reason: reason))
			}
			
			return .success(T.collection(response: response, representation: jsonObject))
		}
		
		return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}
