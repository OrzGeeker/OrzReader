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
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
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
        return items?.count ?? 0
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
