//
//  CLPlacemarkExtensions.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 12/9/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//
import CoreLocation

extension CLPlacemark{
	public func stringFromPlacemark() -> String {
		var text = ""
		if let s = self.subThoroughfare {
			text += s + " "
		}
		if let s = self.thoroughfare {
			text += s + ", "
		}
		if let s = self.locality {
			text += s + ", "
		}
		if let s = self.administrativeArea {
			text += s + " "
		}
		if let s = self.postalCode {
			text += s + ", "
		}
		if let s = self.country {
			text += s
		}
		return text
	}
}