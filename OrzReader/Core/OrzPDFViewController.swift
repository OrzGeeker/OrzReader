//
//  OrzPDFViewController.swift
//  jokerHub
//
//  Created by joker on 2018/4/19.
//  Copyright © 2018年 joker. All rights reserved.
//
import UIKit
import PDFKit
import SnapKit

@available(iOS 11.0, *)
class OrzPDFViewController: UIViewController {
    
    // PDF文件相关信息
    var pdfInfo: OrzPDFInfo? {
        didSet {
            setupUI()
        }
    }
    
    // 数据无效时的提示视图
    lazy var emptyView: UIView = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "无数据"
        let emptyView = UIView(frame: CGRect.zero)
        emptyView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return emptyView
    }()
    
    // 数据有效时用来展示PDF视图
    var pdfView: OrzPDFView?
    
    // 阅读进度条
    var readProcessBar = UIProgressView(progressViewStyle: .bar)
    
    // PDF视图展示模式
    enum PageMode {
        case contentToFill
        case pageToFill
    }

    // PDF视图当前展示模式
    var pageMode: PageMode = .pageToFill
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.configPageDisplayStyleWithPageWidth(self.view.frame.size.width)
        }, completion: { (context) in
            self.configPageDisplayStyleWithPageWidth(self.view.frame.size.width)
        })
    }
    
    deinit {
        removeRegisterNotification()
    }
}


// 配置相关
extension OrzPDFViewController {
    
    func setupUI() {

        // 配置页面背景色
        self.view.backgroundColor = .white
        
        // 配置导航条
        configureNavigationBar()
        
        // 配置PDF视图
        configurePDFView()
        
        // 配置空视图
        configureEmptyView()
    }
    
    /// 配置导航条
    func configureNavigationBar() {
        self.title = self.pdfInfo?.title
    }
    
    func configurePDFView() {
    
        guard let pdfInfo = self.pdfInfo, let pdfURL = pdfInfo.url else {
            self.pdfView?.removeFromSuperview()
            self.pdfView = nil
            return
        }
        
        if let pdfView = self.pdfView {
            if let documentURL = pdfView.document?.documentURL, pdfURL != documentURL {
                pdfView.document = PDFDocument(url: pdfURL)
            }
        } else{
            pdfView = OrzPDFView(url: pdfURL)
            self.view.addSubview(pdfView!)
            pdfView!.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            //PDF阅读进度条，视图底部
            self.view.addSubview(readProcessBar)
            readProcessBar.snp.makeConstraints { (make) in
                make.width.bottom.equalToSuperview()
                make.height.equalTo(2)
            }
            
            //注册通知事件处理器
            registerNotification()
            
            // 添加手势
            addGesture()
        }
        
        // 配置页面显示样式
        configPageDisplayStyleWithPageWidth(self.view.bounds.size.width)
    }
    
    func configureEmptyView() {
        guard pdfInfo == nil else {
            return
        }
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 配置页面显示样式
    func configPageDisplayStyleWithPageWidth(_ width: CGFloat) {
        switch pageMode {
        case .pageToFill:
            pdfView?.pageWidthToFitWidth(width)
        case .contentToFill:
            pdfView?.contentWidthFitWidth(width)
        }
    }
}

// MARK: 页面手势
@available(iOS 11.0, *)
extension OrzPDFViewController {
    
    /// 添加手势
    func addGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2;
        self.view.addGestureRecognizer(doubleTap)
    }
    
    /// 双击手势处理
    @objc func doubleTapAction(_ doubleTap: UITapGestureRecognizer) {
        if pageMode == .pageToFill {
            pageMode = .contentToFill
        } else {
            pageMode = .pageToFill
        }
        configPageDisplayStyleWithPageWidth(self.view.bounds.size.width)
    }
}

// MARK: 通知
@available(iOS 11.0, *)
extension OrzPDFViewController {
    
    /// 注册相关通知事件处理
    func registerNotification() {
        
        // 进后台时保存当前阅读进度
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        // 加载页面时更新底部阅读进度条
        NotificationCenter.default.addObserver(self, selector: #selector(pdfViewPageChanged(notification:)), name: .PDFViewPageChanged, object: nil)
    }
    
    /// 应用后台时处理事件
    ///
    /// - Parameter notification: 通知信息结构
    @objc func appWillResignActive(notification: NSNotification) {
//        saveReadProcess()
    }
    
    /// pdf页面变化通知处理
    /// 更新文档阅读进度条
    ///
    /// - Parameter notification: 通知信息结构
    @objc func pdfViewPageChanged(notification: NSNotification) {
        if
            let pdfView = self.pdfView,
            let currentPageNumber = pdfView.currentPage?.pageRef?.pageNumber,
            let totalPages = pdfView.document?.pageCount {
            let process: Float = Float(currentPageNumber) / Float(totalPages)
            self.readProcessBar.progress = process
        } else {
            self.readProcessBar.progress = 0
        }
    }
    
    /// 取消通知注册
    func removeRegisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: 文档阅读进度
@available(iOS 11.0, *)
extension OrzPDFViewController {
    
    /// 保存当前阅读进度
    func saveReadProcess() {
        if let pdfView = self.pdfView, let pdfInfo = self.pdfInfo {
            let visiblePages = pdfView.visiblePages()
            if let destination = pdfView.currentDestination,
                let page = visiblePages.first?.pageRef?.pageNumber {
                let point = destination.point
                var pageHeights = visiblePages[1..<visiblePages.count].reduce(0) { (result, p) -> CGFloat in
                    return result + p.bounds(for: pdfView.displayBox).size.height
                }
                pageHeights -= point.y
                let height = pdfView.bounds.size.height / pdfView.scaleFactor
                let pointY = height - pageHeights
            
                pdfInfo.saveProcess(pageNum: page-1, offsetX: point.x, offsetY: pointY)
            }
        }
    }
    
    /// 加载阅读进度
    func reloadReadProcess() {
        if let pdfView = self.pdfView, let pdfInfo = self.pdfInfo,
            let page = pdfView.document?.page(at: pdfInfo.pageNumber) {
            let offset = CGPoint(x: pdfInfo.offsetX, y: pdfInfo.offsetY)
            let destination = PDFDestination(page: page, at: offset)
            pdfView.go(to: destination)
        }
    }
}

