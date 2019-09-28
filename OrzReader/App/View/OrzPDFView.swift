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

    var pdfInfo: OrzPDFInfo
    
    @Binding var contentMode: OrzPDFPageContentMode
    
    func makeUIView(context: UIViewRepresentableContext<OrzPDFView>) -> PDFView {
         
        let pdfView = PDFView(frame: .zero)
        if let pdfUrl = pdfInfo.pdfUrl, let document = PDFDocument(url: pdfUrl) {
            pdfView.document = document
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.displaysPageBreaks = false
            pdfView.autoScales = false
            pdfView.delegate = context.coordinator
            context.coordinator.pdfView = pdfView
            context.coordinator.configNotification()
            removeDoubleTapGestures(pdfView)
            
            
        }
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: UIViewRepresentableContext<OrzPDFView>) {
        layoutPDFView(pdfView)
    }
    
    func makeCoordinator() -> PDFViewCoordinator {
        return PDFViewCoordinator()
    }
}

extension OrzPDFView {
    
    func removeDoubleTapGestures(_ pdfView: PDFView) {
        pdfView.gestureRecognizers = pdfView.gestureRecognizers?.filter({ (gesture) -> Bool in
            if let tapGesture = gesture as? UITapGestureRecognizer,
            tapGesture.numberOfTapsRequired == 2 {
                return false // 移除所有的双击手势
            } else {
                return true
            }
        })
    }
    
    func layoutPDFView(_ pdfView: PDFView) {
        
        guard let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let isLandscape = currentWindowScene.interfaceOrientation == .landscapeLeft || currentWindowScene.interfaceOrientation == .landscapeRight
        let screenWidth = currentWindowScene.screen.bounds.size.width

        switch contentMode {
        case .aspectFit:
            let displayWidth = screenWidth
            if let contentWidth = pdfView.currentPage?.bounds(for: pdfView.displayBox).size.width {
                let scale = displayWidth / contentWidth
                setPDFView(pdfView, with: scale)
            }
        case .aspectFill:
            let leftPadding = isLandscape ? pdfView.safeAreaInsets.left : 5
            let displayWidth = screenWidth - leftPadding * 2
            if let pageImage = pdfView.currentPage?.thumbnail(of: pdfView.bounds.size, for: pdfView.displayBox),
                let pageWidth = pdfView.currentPage?.bounds(for: pdfView.displayBox).size.width {
                let contentWidth = pageWidth * OpenCV.contentWidthRatio(of: pageImage)
                let scale = displayWidth / contentWidth
                setPDFView(pdfView, with: scale)
            }
        }
    }
    
    func setPDFView(_ pdfView: PDFView, with scale: CGFloat) {
    
        pdfView.minScaleFactor = scale
        pdfView.maxScaleFactor = scale
        
        // 设置两次才行正常布局
        pdfView.scaleFactor = scale
        pdfView.scaleFactor = scale
        
        if let scrollView = try! pdfView.subviews.filter({ (subview) throws -> Bool in
            return subview is UIScrollView
            }).first as? UIScrollView {
            // 禁止水平滑动
            scrollView.contentSize.width = 0
        }
    }
}
