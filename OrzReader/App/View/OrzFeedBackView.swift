
//
//  OrzFeedBackView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/10/12.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI
import PinpointKit

struct OrzFeedBackView: UIViewControllerRepresentable {
    
    var isShow: Bool = false
    
    let viewController = UIViewController()
    
    let pinpointKit = PinpointKit(feedbackRecipients: ["824219521@qq.com"])
    
    func makeCoordinator() -> OrzFeedBackView.Coordinator {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<OrzFeedBackView>) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<OrzFeedBackView>) {
        if isShow {
            pinpointKit.show(from: viewController)
        }
    }
}


