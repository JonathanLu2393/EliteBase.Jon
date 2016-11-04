//
//  IPromoCodeService.swift
//  EliteBase
//
//  Created by Jonathan Lu on 10/28/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//
import Foundation

public protocol IPromoCodeService {
    func applyPromoCodeForUser(_ promoCode: String, completion:@escaping (_ success : Bool, _ message : String) -> Void )
    func getCouponsForUser(_ completion: @escaping (_ success : Bool, _ coupons : [ApiCoupon]?) -> Void )
    func couponBalance(coupon: ApiCoupon) -> String
}
