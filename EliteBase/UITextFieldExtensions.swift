//
//  UITextFieldExtensions.swift
//  EliteTutoring
//
//  Created by Eric Heitmuller on 10/22/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


extension UITextField {
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self.text)
        
        return result
    }
    
    public func isValidPhoneNumber() -> Bool {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let result = phoneTest.evaluate(with: self.text)
        
        return result
    }
    
    //Requires 6 characters, 1 uppercase, 1 lowercase, 1 number
    public func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: self.text)
        
        return result
    }
    
    public func isValidCreditCardNumber() -> Bool {
        let creditCardNumberRegEx = "^(?=.*?[0-9]).{13,}$"
        let creditCardTest = NSPredicate(format: "SELF MATCHES %@", creditCardNumberRegEx)
        let result = creditCardTest.evaluate(with: self.text)
        
        return result
    }
    
    public func isValidFullName() -> Bool {
        let nameArray: [String] = self.text!.characters.split { $0 == " " }.map { String($0) }
        return nameArray.count >= 2
    }
    
    public func isValidXDigitNumber(_ digits : Int) -> Bool {
        let digitsRegEx = "\\d{\(digits)}"
        let digitsTest = NSPredicate(format: "SELF MATCHES %@", digitsRegEx)
        let result = digitsTest.evaluate(with: self.text)
        
        return result
    }
    
    public func isValidTwoDigitMonth() -> Bool {
        let twoDigitsRegEx = "\\d{2}"
        let twoDigitsTest = NSPredicate(format: "SELF MATCHES %@", twoDigitsRegEx)
        let result = twoDigitsTest.evaluate(with: self.text)
        
        let isValidMonth = (Int(self.text!) <= 12)
        
        return (result && isValidMonth)
    }
    
    public func isValidFourDigitExpirationYear() -> Bool {
        let fourDigitsRegEx = "\\d{4}"
        let fourDigitsTest = NSPredicate(format: "SELF MATCHES %@", fourDigitsRegEx)
        let result = fourDigitsTest.evaluate(with: self.text)
        
        let todayDate = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.year, from: todayDate)
        
        let year =  components.year
        
        let isValidYear = ( (Int(self.text!)! <= year! + 10) && (Int(self.text!)! >= year!) )
        
        return (result && isValidYear)
    }
    
    public func setErrorStateOn(){
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.5
    }
    
    public func setErrorStateOff(){
        self.layer.borderWidth = 0
    }
    
    public func indent(){
        self.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0)
    }
    
    public func ccNumberFormatCheck(_ shouldInsertDash: [Bool]) -> [Bool] {
        var shouldInsertDashArray = shouldInsertDash
        
        if(self.text!.characters.count == 3) {
            shouldInsertDashArray[0] = true
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count == 4 && shouldInsertDash[0] == true) {
            self.text = self.text! + "-"
            shouldInsertDashArray[0] = false
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count == 8) {
            shouldInsertDashArray[1] = true
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count == 9 && shouldInsertDash[1] == true) {
            self.text = self.text! + "-"
            shouldInsertDashArray[1] = false
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count == 13) {
            shouldInsertDashArray[2] = true
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count == 14 && shouldInsertDash[2] == true) {
            self.text = self.text! + "-"
            shouldInsertDashArray[2] = false
            return shouldInsertDashArray
        }
        
        if(self.text!.characters.count > 19) {
            self.deleteBackward()
            return shouldInsertDashArray
        }
        
        return shouldInsertDash
    }
}
