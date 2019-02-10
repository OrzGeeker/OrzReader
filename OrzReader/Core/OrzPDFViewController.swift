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
    
    lazy var lockScreenButton: UIButton = {
        let lockScreenButton = UIButton(type: .system)
        lockScreenButton.setTitle("Lock", for: .normal)
        lockScreenButton.addTarget(self, action: #selector(lockScreenAction(_:)), for: .touchUpInside)
        return lockScreenButton
    }()
    
    var isLockScreenSelected: Bool {
        get {
            return (OrzConfigManager.shared.supportedInterfaceOrientations != .allButUpsideDown)
        }
    }
    
    // 数据有效时用来展示PDF视图
    var pdfView: OrzPDFView?
    
    // 阅读进度条
    var readProcessBar = UIProgressView(progressViewStyle: .bar)
    
    // PDF视图展示模式
    enum PageMode: Int {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadReadProcess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveReadProcess()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        OrzConfigManager.shared.supportedInterfaceOrientations = .allButUpsideDown
        lockScreenButton.isSelected = isLockScreenSelected
    }
    
    override func didReceiveMemoryWarning() {
        saveReadProcess()
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
        
        // 设置标题
        self.title = self.pdfInfo?.title
        
        // 配置导航条
        configureNavigationBar()
        
        // 配置PDF视图
        configurePDFView()
        
        // 配置空视图
        configureEmptyView()
    }
    
    /// 配置导航条
    func configureNavigationBar() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.hidesBarsOnTap = true
        
        let lockScreenBarBtnItem = UIBarButtonItem(customView: lockScreenButton)
        lockScreenButton.isSelected = isLockScreenSelected
        
        self.navigationItem.rightBarButtonItem = lockScreenBarBtnItem
    }
    
    @objc func lockScreenAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if OrzConfigManager.shared.supportedInterfaceOrientations != .allButUpsideDown {
            OrzConfigManager.shared.supportedInterfaceOrientations = .allButUpsideDown
        } else {
        
            var supportedInterfaceOrientationMask: UIInterfaceOrientationMask = .allButUpsideDown
            
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                supportedInterfaceOrientationMask = .portrait
            case .landscapeLeft:
                supportedInterfaceOrientationMask = .landscapeLeft
            case .landscapeRight:
                supportedInterfaceOrientationMask = .landscapeRight
            case .portraitUpsideDown:
                supportedInterfaceOrientationMask = .portraitUpsideDown
            case .unknown:
                supportedInterfaceOrientationMask = .allButUpsideDown
            }
            OrzConfigManager.shared.supportedInterfaceOrientations = supportedInterfaceOrientationMask
        }
    }
    
    func configurePDFView() {
    
        guard let pdfInfo = self.pdfInfo, let pdfURL = pdfInfo.url else {
            self.pdfView?.removeFromSuperview()
            self.pdfView = nil
            return
        }
        
        if let pdfView = self.pdfView {
            if pdfView.document?.documentURL != pdfURL { pdfView.document = PDFDocument(url: pdfURL) }
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
        if let hideBarsOnTapGesture = self.navigationController?.barHideOnTapGestureRecognizer {
            hideBarsOnTapGesture.require(toFail: doubleTap)
        }
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
        saveReadProcess()
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
        if
            let pdfView = self.pdfView,
            let pdfInfo = self.pdfInfo,
            !pdfInfo.isInvalidated {
            
            pdfInfo.saveProcess(pdfView.scrollView.contentOffset, self.pageMode.rawValue)
        }
    }
    
    /// 加载阅读进度
    func reloadReadProcess() {
        if
            let pdfView = self.pdfView,
            let pdfInfo = self.pdfInfo,
            !pdfInfo.isInvalidated {
            
            let contentOffset = CGPoint(x: pdfInfo.contentOffsetX, y: pdfInfo.contentOffsetY)
            self.pageMode = PageMode(rawValue: pdfInfo.pageMode)!
            configPageDisplayStyleWithPageWidth(self.view.bounds.size.width)
            pdfView.scrollView.setContentOffset(contentOffset, animated: false)
        }
    }
}

