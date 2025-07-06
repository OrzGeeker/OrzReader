//
//  OrzPDFView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/5.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import Logging
import PDFKit
import SwiftUI

struct OrzPDFView {

    let pdfInfo: OrzPDFInfo

    let scaleFactor: CGFloat

    private let pdfView = PDFView()

    func makeView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: pdfInfo.fileUrl)
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.displaysPageBreaks = false
        pdfView.displayBox = .mediaBox
        return pdfView
    }

    func updateView(_ view: PDFView, context: Context) {
        pdfView.scaleFactor = scaleFactor
        pdfView.minScaleFactor = scaleFactor
        pdfView.maxScaleFactor = scaleFactor
    }
}

#if os(macOS)
    extension OrzPDFView: NSViewRepresentable {
        func makeNSView(context: Context) -> some NSView {
            return makeView(context: context)
        }
        func updateNSView(_ nsView: NSViewType, context: Context) {
            updateView(pdfView, context: context)
        }
    }
#else
    extension OrzPDFView: UIViewRepresentable {
        func makeUIView(context: Context) -> PDFView {
            return makeView(context: context)
        }
        func updateUIView(_ uiView: PDFView, context: Context) {
            updateView(uiView, context: context)
        }
    }
#endif

#Preview {
    OrzPDFView(pdfInfo: mockPDF, scaleFactor: 1)
}
