//
//  OrzPDFView.swift
//  jokerHub
//
//  Created by joker on 2018/4/26.
//  Copyright © 2018年 joker. All rights reserved.
//

import PDFKit
import CoreGraphics

@available(iOS 11.0, *)
class OrzPDFView: PDFView {
    
    var scale: CGFloat {
        
        set(newScale) {
            scaleFactor = newScale
            minScaleFactor = newScale
            maxScaleFactor = newScale
        }
        
        get {
            return scaleFactor
        }
    }
    
    var scrollView: UIScrollView!
    
    init(url: URL) {
        super.init(frame: CGRect.zero)
        
        let pdf = PDFDocument(url: url)
        pdf?.delegate = self;
        document = pdf
        displayMode = .singlePageContinuous
        displaysPageBreaks = false
        displayDirection = .vertical
        subviews.forEach { (subview) in
            if let scrollView = subview as? UIScrollView {
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                scrollView.scrollsToTop = false
                self.scrollView = scrollView
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 11.0, *)
extension OrzPDFView {
    
    // 内容宽度适配屏宽
    func contentWidthFitWidth(_ width: CGFloat) {
        if let size = self.currentPage?.bounds(for: displayBox).size {
            let pageImg = self.currentPage?.thumbnail(of: size, for: displayBox)
            let contentRatio = OpenCV.contentWidthRatio(of: pageImg)
            let padding: CGFloat = 10.0
            let contentWidth = size.width * contentRatio + padding
            let contentScaleFactor =  width / contentWidth
            self.scale = contentScaleFactor
            self.scale = contentScaleFactor
            if let documentView = self.documentView {
                documentView.frame.origin.x = (width - documentView.frame.width) /
                2.0
                self.scrollView.contentSize.width = width;
            }

        }
    }
    
    // 页面宽度适配屏宽
    func pageWidthToFitWidth(_ width: CGFloat) {
        if let pageWidth = self.currentPage?.bounds(for: self.displayBox).size.width {
            let contentScaleFactor = width / pageWidth
            self.scale = contentScaleFactor
            self.scale = contentScaleFactor
            if let documentView = self.documentView {
                documentView.frame.origin.x = (width - documentView.frame.width) /
                2.0
                self.scrollView.contentSize.width = width;
            }
        }
    }
}

@available(iOS 11.0, *)
extension OrzPDFView: PDFDocumentDelegate {
    func classForPage() -> AnyClass {
        return OrzPDFPage.self
    }
}
