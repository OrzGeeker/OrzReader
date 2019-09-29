//
//  OrzPDFViewCoordinator.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/27.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import PDFKit

class PDFViewCoordinator: NSObject, PDFViewDelegate {
    var view: OrzPDFView

    init(_ view: OrzPDFView) {
        self.view = view        
    }
    
    func configNotification() {
        view.readProcessSubscription = NotificationCenter.default.publisher(for: .PDFViewPageChanged).sink { (notification) in
            if let currentPageNumber = self.view.pdfView.currentPage?.pageRef?.pageNumber,
                let totalPageNumber = self.view.pdfView.document?.pageCount {
                self.view.progress =  Float(currentPageNumber) / Float(totalPageNumber)
                print(self.view.progress)
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
