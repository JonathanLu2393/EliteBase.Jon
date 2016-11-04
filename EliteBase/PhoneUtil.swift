//
//  PhoneUtil.swift
//  EliteBase
//
//  Created by Eric Heitmuller on 5/4/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class PhoneUtil{
	open static func callNumber(_ phoneNumber:String?){
	
		guard let number = phoneNumber else {
			return;
		}
		
		let strippedStr = number.replacingOccurrences(of: "[^0-9 ]", with: "", options: NSString.CompareOptions.regularExpression, range:nil);
		
		callNumberFormatted(strippedStr)
		
	}
	
	//phone number needs to be in 1234567890 format w/o dashes or spaces
	fileprivate static func callNumberFormatted(_ formattedPhoneNumber:String) {
		if let phoneCallURL:URL = URL(string: "tel://\(formattedPhoneNumber)") {
			let application:UIApplication = UIApplication.shared
			if (application.canOpenURL(phoneCallURL)) {
				application.openURL(phoneCallURL);
			}
		}
	}
	
}
