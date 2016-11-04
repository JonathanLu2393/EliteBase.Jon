//
//  Blocks.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 12/30/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import Foundation

public final class ApiBlock : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
	
	public var blockId : String!
    public var userId : String!
    public var blockType : BlockType!
    public var sessionId : String?
    public var transactionId: String?
    public var bookingId: String?
    public var paymentCustomerId : String?
    
    public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: Any] else { return nil }
        
        self.userId = representation["userId"] as! String
        self.blockType = BlockType(rawValue: (representation["blockType"] as! Int))
		self.blockId = representation["_id"] as! String
	
        if(self.blockType == BlockType.transactionFailure) {
            self.transactionId = representation["transactionId"] as? String
            self.bookingId = representation["bookingId"] as? String
            self.paymentCustomerId = representation["paymentCustomerId"] as? String
        } else {
            self.sessionId = representation["sessionId"] as? String
        }
    }
}
