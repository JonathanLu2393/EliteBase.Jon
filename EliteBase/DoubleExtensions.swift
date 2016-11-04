//
//  DoubleExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

extension Double {
    public func string(_ numberOfDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = numberOfDigits
        formatter.maximumFractionDigits = numberOfDigits
		let number = NSNumber(value: self)
        let string = formatter.string(from: number)
		return string ?? "\(self)"
    }
}
