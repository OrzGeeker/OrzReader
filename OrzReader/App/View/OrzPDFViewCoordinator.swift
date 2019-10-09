//
//  OrzPDFViewCoordinator.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/27.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import PDFKit
import Combine

class PDFViewCoordinator: NSObject {
    var view: OrzPDFView
    var readProcessSubscription: AnyCancellable? = nil
    var saveReadPageSubscription: Any? = nil
    
    var isGotoLastReadPage: Bool = true
    
    init(_ view: OrzPDFView) {
        self.view = view
    }
    
    func configNotification() {
        readProcessSubscription = NotificationCenter.default.publisher(for: .PDFViewPageChanged).sink { (notification) in
            if let currentPageNumber = self.view.pdfView.currentPage?.pageRef?.pageNumber,
                let totalPageNumber = self.view.pdfView.document?.pageCount {
                self.view.pdfStore.progress =  Float(currentPageNumber) / Float(totalPageNumber)
            }
        }
        saveReadPageSubscription = view.pdfStore.savePublisher.sink { (_) in
            self.saveLastReadPage()
        }
    }
    
    func updateContentMode() {

        guard let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let isLandscape = currentWindowScene.interfaceOrientation == .landscapeLeft || currentWindowScene.interfaceOrientation == .landscapeRight
        
        guard view.lastContentMode != view.pdfStore.contentMode || view.isLandscape != isLandscape else {
            return
        }
        view.lastContentMode = view.pdfStore.contentMode
        view.isLandscape = isLandscape
        
        let screenWidth = currentWindowScene.screen.bounds.size.width
        
        if let currentPageSize = view.pdfView.currentPage?.bounds(for: view.pdfView.displayBox).size {
            switch view.pdfStore.contentMode {
            case .aspectFit:
                let displayWidth = screenWidth
                let contentWidth = currentPageSize.width
                    let scale = displayWidth / contentWidth
                    setPDFView(with: scale)
            case .aspectFill:
                let leftPadding: CGFloat = isLandscape ? 44.0 : 5.0
                let displayWidth = screenWidth - leftPadding * 2
                let thumbnailSize = CGSize(width: currentPageSize.width / 4, height: currentPageSize.height / 4)
                if let pageImage = view.pdfView.currentPage?.thumbnail(of: thumbnailSize, for: view.pdfView.displayBox),
                    let pageWidth = view.pdfView.currentPage?.bounds(for: view.pdfView.displayBox).size.width {
                    let contentWidth = pageWidth * OpenCV.contentWidthRatio(of: pageImage)
                    let scale = displayWidth / contentWidth
                    setPDFView(with: scale)
                }
            }
        }
    }
    
    func setPDFView(with scale: CGFloat?) {
    
        if let scale = scale {
            view.pdfView.minScaleFactor = scale
            view.pdfView.maxScaleFactor = scale
            
            // 设置两次才行正常布局
            view.pdfView.scaleFactor = scale
            view.pdfView.scaleFactor = scale
            
            if let scrollView = try! view.pdfView.subviews.filter({ (subview) throws -> Bool in
                return subview is UIScrollView
            }).first as? UIScrollView {
                // 禁止水平滑动
                scrollView.contentSize.width = 0
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
    
    // 保存阅读进度
    func saveLastReadPage() {
        
        if let pageNumber = view.pdfView.currentDestination?.page?.pageRef?.pageNumber,
            let point = view.pdfView.currentDestination?.point,
            let zoom = view.pdfView.currentDestination?.zoom,
            let pageMode = view.lastContentMode {
            
            view.pdfInfo.savePageNumber(pageNumber, location: point, zoom: zoom, pageMode: pageMode)
        }
    }
    
    func goToLastReadPage() {
        
        guard isGotoLastReadPage else { return }
        
        let visiblePages = view.pdfView.visiblePages.map({ (page) -> Int in
            return (page.pageRef?.pageNumber ?? 1)
        })
        
        let lastPageNumber = view.pdfInfo.lastPageNumber
        
        guard visiblePages.contains(lastPageNumber) else {
            
            if let lastPage = view.pdfView.document?.page(at: lastPageNumber) {
                view.pdfView.go(to: lastPage)
            }
            
            return
        }
        
        isGotoLastReadPage = false
    }
}
