//
//  StatusUtilities.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 2/17/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import MBProgressHUD

open class StatusUtilities {

	open static func loadingScreen(_ view : UIView, description : String){
		let loggingInNotification = MBProgressHUD.showAdded(to: view, animated: true)
		loggingInNotification.mode = MBProgressHUDMode.indeterminate
		loggingInNotification.labelText = NSLocalizedString(description, comment: "")
	}

	open static func loadingScreen(_ view : UIView){
		StatusUtilities.loadingScreen(view, description: "Loading...");
	}
	
	open static func dimissLoadingScreen(_ view: UIView){
		MBProgressHUD.hide(for: view, animated: true)
	}
}
