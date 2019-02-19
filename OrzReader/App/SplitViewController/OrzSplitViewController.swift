//
//  OrzSplitViewController.swift
//  OrzReader
//
//  Created by joker on 2019/2/7.
//  Copyright © 2019 joker. All rights reserved.
//

import UIKit

class OrzSplitViewController: UISplitViewController {
    convenience init (_ delegate: UISplitViewControllerDelegate?, displayMode: UISplitViewController.DisplayMode = .primaryOverlay) {
        self.init()
        
        let master = OrzNavigationController(rootViewController: OrzMasterViewController())
        
        let detailVC = OrzDetailViewController()
        detailVC.pdfInfo = OrzPDFInfo.first()
        let detail = OrzNavigationController(rootViewController: detailVC)
        
        // 配置分割控制器
        self.viewControllers = [master, detail]
        self.preferredDisplayMode = displayMode
        self.delegate = delegate
    }
    
    func showDetailViewController(_ pdfInfo: OrzPDFInfo?) {
        if let pdfInfo = pdfInfo {
            
            if let nvc = self.viewControllers.last as? OrzNavigationController {
                if let _ = nvc.topViewController as? OrzMasterViewController {
                    let detailVC = OrzDetailViewController()
                    detailVC.pdfInfo = pdfInfo
                    let detailNVC = OrzNavigationController(rootViewController: detailVC)
                    detailNVC.hidesBarsOnSwipe = true
                    detailNVC.hidesBarsOnTap = true
                    self.showDetailViewController(detailNVC, sender: nil)
                } else if let detailVC = nvc.topViewController as? OrzDetailViewController {
                    detailVC.pdfInfo = pdfInfo
                } else if let detailNVC = nvc.topViewController as? OrzNavigationController,
                    let detailVC = detailNVC.topViewController as? OrzDetailViewController {
                    detailVC.pdfInfo = pdfInfo
                }
            }
        }
    }
}

extension OrzSplitViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            if let nav = self.viewControllers.last as? OrzNavigationController {
                if let detailVC = nav.topViewController as? OrzDetailViewController {
                    if let pdfInfo = detailVC.pdfInfo, pdfInfo.isInvalidated {
                        detailVC.pdfInfo = nil
                    }
                } else if let detailNVC = nav.topViewController as? OrzNavigationController,
                    let detailVC = detailNVC.topViewController as? OrzDetailViewController {
                    if let pdfInfo = detailVC.pdfInfo, pdfInfo.isInvalidated {
                        detailVC.pdfInfo = nil
                    }
                }
            }
        }, completion: nil)
    }
}

// Debug Helper
extension OrzSplitViewController {
    class func showChildViewController(_ vc: UIViewController, _ level: Int = 0) {
        
        if vc.children.count <= 0 {
            return
        }
        
        var leading = ""
        for _ in 0 ..< level {
            leading = leading + "\t"
        }
        
        for child in vc.children {
            print(leading + child.description)
            showChildViewController(child, level + 1)
        }
    }
}

#if DEBUG

import FLEX

extension OrzSplitViewController {
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resignFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            FLEXManager.shared().showExplorer()
        }
    }
}
#endif
