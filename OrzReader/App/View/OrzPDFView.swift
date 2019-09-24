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
        pdfView.layoutDocumentView()
        if  let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let size = pdfView.currentPage?.bounds(for: pdfView.displayBox).size {
            var screenWidth = currentWindowScene.screen.bounds.size.width
            let contentScaleFactor = screenWidth / size.width
            pdfView.scaleFactor = contentScaleFactor
            pdfView.minScaleFactor = contentScaleFactor
            pdfView.maxScaleFactor = contentScaleFactor
        }
    }
}

extension OrzPDFView {
}
