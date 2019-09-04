//
//  AppDelegate.swift
//  OrzReader
//
//  Created by joker on 2019/2/7.
//  Copyright © 2019 joker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = OrzSplitViewController(OrzSplitViewControllerDelegate())
        return window 
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.makeKeyAndVisible()
        return true
    }
    
    // 从其它应用打开PDF
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let splitVC = UIApplication.shared.keyWindow?.rootViewController as? OrzSplitViewController {
            if let pdfInfo = OrzPDFInfo(url: url) {
                pdfInfo.save()
                splitVC.showDetailViewController(pdfInfo)
                return true
            }
        }
        
        return false
    }
    
    // 锁屏设置
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrzConfigManager.shared.supportedInterfaceOrientations
    }
}
