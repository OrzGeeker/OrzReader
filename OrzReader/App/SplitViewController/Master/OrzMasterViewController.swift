//
//  OrzMasterViewController.swift
//  OrzReader
//
//  Created by joker on 2019/2/7.
//  Copyright © 2019 joker. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class OrzMasterViewController: UIViewController {
    
    private var items: Results<OrzPDFInfo>?
    private var itemsToken: NotificationToken?
    
    var tableView: UITableView!
    let tableViewCellId = "cell"
    
    lazy var emptyView: UIView = {
       
        let empty = UIView(frame: CGRect.zero)
        
        let tip = UILabel(frame: CGRect.zero)
        tip.numberOfLines = 2
        tip.text = "还没有导入图书，您可以使用分享功能或AirDrop从其它应用导入PDF图书进行阅读"
        
        empty.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        empty.isHidden = true
        return empty
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = OrzPDFInfo.all()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemsToken = items?.observe{[weak tableView] (changes) in
            guard let tableView = tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
    
    func setupUI() {
        
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.navigationItem.title = "图书列表"
    }
}

extension OrzMasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            items?[indexPath.row].delete()
            if
                let nvc = self.splitViewController?.viewControllers.last as? OrzNavigationController,
                let detailVC = nvc.topViewController as? OrzDetailViewController,
                let _ = detailVC.pdfInfo?.isInvalidated { detailVC.pdfInfo = nil }
        default:
            break
        }

    }
}

extension OrzMasterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = items?.count ?? 0
        emptyView.isHidden = itemCount > 0
        tableView.isHidden = !emptyView.isHidden
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        if let pdfInfo = items?[indexPath.row] as OrzPDFInfo? {
            cell.textLabel?.text = pdfInfo.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let splitVC = self.splitViewController as? OrzSplitViewController {
            splitVC.showDetailViewController(items?[indexPath.row])
        }
    }
}
