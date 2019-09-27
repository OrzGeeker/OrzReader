//
//  OrzPDFViewCoordinator.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/27.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import PDFKit

class PDFViewCoordinator: NSObject, PDFViewDelegate {
    
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
