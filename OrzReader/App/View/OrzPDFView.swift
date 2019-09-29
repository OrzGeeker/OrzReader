//
//  OrzPDFView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/5.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI
import PDFKit

struct OrzPDFView: UIViewRepresentable {
    
    @EnvironmentObject var pdfStore: OrzPDFStore
    
    var pdfInfo: OrzPDFInfo
    
    var pdfView = PDFView(frame: .zero)
    
    var scale: CGFloat?
    
    var lastContentMode: OrzPDFPageContentMode?
    
    func makeUIView(context: UIViewRepresentableContext<OrzPDFView>) -> PDFView {
        
        if let pdfUrl = pdfInfo.pdfUrl, let document = PDFDocument(url: pdfUrl) {
            pdfView.document = document
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.displaysPageBreaks = false
            pdfView.autoScales = false
            pdfView.delegate = context.coordinator
            
            removeDoubleTapGestures()
        }
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: UIViewRepresentableContext<OrzPDFView>) {
        context.coordinator.updateContentMode()
    }
    
    func makeCoordinator() -> PDFViewCoordinator {
        let coordinator = PDFViewCoordinator(self)
        coordinator.configNotification()
        return coordinator
    }
}

extension OrzPDFView {
    
    func removeDoubleTapGestures() {
        pdfView.gestureRecognizers = pdfView.gestureRecognizers?.filter({ (gesture) -> Bool in
            if let tapGesture = gesture as? UITapGestureRecognizer,
            tapGesture.numberOfTapsRequired == 2 {
                return false // 移除所有的双击手势
            } else {
                return true
            }
        })
    }
}

// MARK: 阅读进度
extension OrzPDFView {
    
    func saveLastReadPage() {
        if let currentPageNumber = pdfView.currentPage?.pageRef?.pageNumber {
            self.pdfInfo.savePageNumber(currentPageNumber)
        }
    }
    
    func goToLastReadPage() {
        if let lastPage = pdfView.document?.page(at: pdfInfo.lastPageNumber) {
            pdfView.go(to: lastPage)
        }
    }
}
