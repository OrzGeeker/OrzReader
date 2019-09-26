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
        }
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: UIViewRepresentableContext<OrzPDFView>) {
        layoutPDFView(pdfView)
    }
}

extension OrzPDFView {
    
    func layoutPDFView(_ pdfView: PDFView) {
        
        guard let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let screenWidth = currentWindowScene.screen.bounds.size.width

        switch contentMode {
        case .aspectFit:
            if let contentWidth = pdfView.currentPage?.bounds(for: pdfView.displayBox).size.width {
                setPDFView(pdfView, with: screenWidth / contentWidth)
            }
        case .aspectFill:
            if let pageImage = pdfView.currentPage?.thumbnail(of: pdfView.bounds.size, for: pdfView.displayBox),
                let pageWidth = pdfView.currentPage?.bounds(for: pdfView.displayBox).size.width {
                setPDFView(pdfView, with: screenWidth / (pageWidth * OpenCV.contentWidthRatio(of: pageImage)))
            }
        }
    }
    
    func setPDFView(_ pdfView: PDFView, with scale: CGFloat) {
    
        pdfView.minScaleFactor = scale
        pdfView.maxScaleFactor = scale
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
