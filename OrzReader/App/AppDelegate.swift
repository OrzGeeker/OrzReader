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
    
    var window: UIWindow?
    
    // 分割控制器代理
    let splitVC = OrzSplitViewController()
    
    let master = OrzNavigationController(rootViewController: OrzMasterViewController())
    let detail = OrzNavigationController(rootViewController: OrzDetailViewController())
    
    let splitVCDelegate = OrzSplitViewControllerDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 创建窗口
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let detailVC = detail.topViewController as? OrzDetailViewController {
            detailVC.pdfInfo = OrzPDFInfo.first()
        }
        
        // 构建分割控制器
        splitVC.viewControllers = [master, detail]
        splitVC.preferredDisplayMode = .primaryOverlay
        splitVC.delegate = splitVCDelegate
        
        // 设置应用根控制器
        window?.rootViewController = splitVC
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
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return OrzConfigManager.shared.supportedInterfaceOrientations
    }
}
