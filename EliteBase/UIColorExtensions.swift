//
//  UIColorExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public static func eliteMediumRed()-> UIColor{
        return UIColor(colorLiteralRed: 221/255, green: 70/255, blue: 61/255, alpha: 1);
    }
    
    public static func eliteGray()-> UIColor{
        return UIColor(colorLiteralRed: 65/255, green: 64/255, blue: 66/255, alpha: 1);
    }
}