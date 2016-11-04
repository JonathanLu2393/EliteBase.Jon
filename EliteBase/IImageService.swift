//
//  IImageService.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/22/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IImageService{
	func getImageSignature(_ completion: @escaping (_ success: Bool, _ signature: ApiImageSignature?)->Void)
    func getImageSignatureForStudent(_ completion: @escaping (_ success: Bool, _ signature: ApiImageSignature?)->Void)
	func UpdateTutorImage(_ url : String, completion: @escaping (_ success : Bool )-> Void)
	func updateUserImage(_ url : String, completion: @escaping (_ success : Bool )-> Void)
}
