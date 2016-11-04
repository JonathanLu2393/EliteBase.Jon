//
//  NSMutableURLRequestExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

extension URLRequest{
    public mutating func addJsonArrayToRequestBody(_ jsonData : [String : AnyObject]){
        self.httpBody = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
    }
}
