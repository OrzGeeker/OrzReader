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
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    let splitVCDelegate = OrzSplitViewControllerDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置应用根控制器
        window?.rootViewController = OrzSplitViewController(splitVCDelegate)
        window?.makeKeyAndVisible()
        return true
    }
    
    // 从其它应用打开PDF
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let ret = OrzReader.openPDF(url)
        if let splitVC = UIApplication.shared.keyWindow?.rootViewController as? OrzSplitViewController {
            splitVC.showDetailViewController(OrzPDFInfo.all().filter("urlStr = '\(url.absoluteString)'").first)
        }
        return ret
    }
    
    // 锁屏设置
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrzConfigManager.shared.supportedInterfaceOrientations
    }
}
