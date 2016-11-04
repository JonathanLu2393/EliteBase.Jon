//
//  PromoCodeService.swift
//  EliteBase
//
//  Created by Jonathan Lu on 10/28/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//
import Foundation
import SwiftyJSON
import Alamofire

open class PromoCodeService : IPromoCodeService {
    
    private var authService : IAuthenticationService
    
    public init(authService : IAuthenticationService){
        self.authService = authService
    }
    
    open func applyPromoCodeForUser(_ promoCode: String, completion:@escaping (_ success : Bool, _ message : String) -> Void ){
        
        authService.getUserLoginData(){
            succss, userLoginData in
            
            do {
                let request = try Router.applyPromoCodeForUser(promoCode, userLoginData!.token).asURLRequest()
                Network.MakeNetworkRequest(request, successHandler: { (jsonData : JSON) in
                    
                    let successResponse = jsonData["success"].bool
                    let messageResponse = jsonData["message"].string
                    
                    if(successResponse == nil || successResponse == false) {
                        completion(false, messageResponse!)
                    }
                    
                    completion(true, "")
                    return
                    
                }) { 
                    completion(false, NSLocalizedString("networkErrorMessage", comment: ""))
                }
            }
            catch let error as AFError {
                print("try/catch failed in applyPromoCodeForUser: \(error)")
                completion(false, NSLocalizedString("networkErrorMessage", comment: ""))
            }
            catch {
                print("try/catch failed in applyPromoCodeForUser")
                completion(false, NSLocalizedString("networkErrorMessage", comment: ""))
            }
        }
    }
    
    open func getCouponsForUser(_ completion: @escaping (_ success : Bool, _ coupons : [ApiCoupon]?) -> Void ){
        authService.getUserLoginData(){
            success, userLoginData in
            
            do {
                let request = try Router.getAllCouponsForUser(userLoginData!.userId, userLoginData!.token).asURLRequest()
                Network.MakeNetworkRequestForCollection(request, successHandler: { (data) in
                    completion(true,  data)
                }, failureHandler: {
                    completion(false, nil)
                })
                
            } catch let error as AFError {
                print("try/catch failed in getCouponsForUser: \(error)")
                completion(false, nil)
            } catch {
                print("try/catch failed unhandled in getCouponsForUser: \(error)")
                completion(false, nil)
            }
        }
    }
    
    open func couponBalance(coupon: ApiCoupon) -> String {
        if(coupon.type == ApiCouponType.amount.rawValue) {
            return String(format: NSLocalizedString("couponType.amount", comment: ""), String(coupon.amount!))
        }
        
        if(coupon.type == ApiCouponType.percent.rawValue) {
            return String(format: NSLocalizedString("couponType.percent", comment: ""), String(coupon.amount!))
        }
        
        if(coupon.type == ApiCouponType.balance.rawValue) {
            return String(format: NSLocalizedString("couponType.balance", comment: ""), String(coupon.amount!))
        }
        
        return String(coupon.amount!)
    }
}
