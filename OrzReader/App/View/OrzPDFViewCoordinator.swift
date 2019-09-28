//
//  OrzPDFViewCoordinator.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/27.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import PDFKit
import Combine
import SwiftUI

class PDFViewCoordinator: NSObject, PDFViewDelegate {
    
    var pdfView: PDFView?
    var pdfInfo: OrzPDFInfo?
    var progress: Float?
    
    var readProcessSubscription: AnyCancellable? = nil

    func configNotification() {
        readProcessSubscription = NotificationCenter.default.publisher(for: .PDFViewPageChanged).sink { (notification) in
            if let currentPageNumber = self.pdfView?.currentPage?.pageRef?.pageNumber,
                let totalPageNumber = self.pdfView?.document?.pageCount {
                self.progress =  Float(currentPageNumber) / Float(totalPageNumber)
            }
        }
    }

    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        print(url)
    }
    
    func pdfViewPerformFind(_ sender: PDFView) {
        print("find")
    }
    
    func pdfViewOpenPDF(_ sender: PDFView, forRemoteGoToAction action: PDFActionRemoteGoTo) {
        
    }
    
    func pdfViewPerformGo(toPage sender: PDFView) {
        
    }
    
    func pdfViewParentViewController() -> UIViewController {
        return UIViewController()
    }
    

}
