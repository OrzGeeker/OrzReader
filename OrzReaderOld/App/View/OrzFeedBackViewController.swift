//
//  OrzFeedBackViewController.swift
//  OrzReader
//
//  Created by wangzhizhou on 2020/1/10.
//  Copyright © 2020 wangzhizhou. All rights reserved.
//

import SwiftUI
import PinpointKit

struct OrzFeedBackViewController: UIViewControllerRepresentable {

    var isShow: Bool = false
    
    let viewController = UIViewController()
    
    let pinpointKit = PinpointKit(feedbackRecipients: ["824219521@qq.com"])
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<OrzFeedBackViewController>) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<OrzFeedBackViewController>) {
        if isShow {
            pinpointKit.show(from: viewController)
        }
    }
}
struct OrzFeedBackViewController_Previews: PreviewProvider {
    static var previews: some View {
        OrzFeedBackViewController()
    }
}
