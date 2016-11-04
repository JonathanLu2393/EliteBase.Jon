//
//  EmailUtil.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 3/18/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class EmailUtil{
	open static func sendEmail(_ email: String){
		let url = URL(string: "mailto:\(email)")!
		UIApplication.shared.openURL(url)
	}
	
	open static func sendTutorSupportEmail(){
		EmailUtil.sendEmail("tutorsupport@elite-app.com")
	}
}
