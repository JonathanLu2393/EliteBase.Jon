//
//  UIViewControllerExtensions.swift
//  EliteTutoring
//
//  Created by Jonathan Lu on 1/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

extension UIWindow {
    public func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        } else {
            if let presentedViewController = vc.presentedViewController {
                return presentedViewController
            } else {
                return vc
            }
        }
    }
}
