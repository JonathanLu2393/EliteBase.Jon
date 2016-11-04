//
//  IBlockPollingService.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 4/14/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

public protocol IBlockPollingService {

    func getRatingBlockSessionInfo(_ completion:@escaping (_ success : Bool, _ block: ApiBlock?, _ session: ApiSession?) -> Void)
	func getTransactionBlockSessionInfo(_ completion:@escaping (_ success : Bool, _ sessionId : String?) -> Void)
	func pollBlocks()
}
