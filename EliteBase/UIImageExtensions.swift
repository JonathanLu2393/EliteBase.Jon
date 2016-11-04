//
//  UIImageExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

extension UIImage {
    public func scaledToSize (_ newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
	
	public func scaledToHalfSize() -> UIImage{
		return scaleToRatio(0.5)
	}
	
	public func scaleToQuarterSize() -> UIImage {
		return scaleToRatio(0.25)
	}
	
	fileprivate func scaleToRatio(_ ratio : CGFloat) -> UIImage{
		let size = self.size.applying(CGAffineTransform(scaleX: ratio, y: ratio))
		let hasAlpha = false
		let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
		
		UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
		self.draw(in: CGRect(origin: CGPoint.zero, size: size))
		
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return scaledImage!
	}
	
}
