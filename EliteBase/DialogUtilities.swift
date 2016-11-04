//
//  ErrorMessageUtilities.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/4/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

open class DialogUtilities {

	fileprivate static func OkDialog(_ title : String, message: String, okAction : ((UIAlertAction) -> Void)? ) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: okAction))
		return alert
	}
	
	open static func presentOkDialog(_ controller : UIViewController, title : String, message: String, okAction : ((UIAlertAction) -> Void)? ){
		
		let dialog = DialogUtilities.OkDialog(title, message: message, okAction: okAction)
		controller.present(dialog, animated: true, completion: nil)
	}
	
	open static func presentYesNoDialog(_ controller : UIViewController, title : String, message: String, yesAction : ((UIAlertAction) -> Void)?, noAction: ((UIAlertAction) -> Void)? )  -> Void {
	
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yesAction))
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: noAction))
	
		controller.present(alert, animated: true, completion: nil)
	}
}
