//
//  OrzPDFInfo.swift
//  OrzReader
//
//  Created by joker on 2019/2/8.
//  Copyright © 2019 joker. All rights reserved.
//

import RealmSwift

@objcMembers class OrzPDFInfo: Object {
    dynamic var id = UUID().uuidString
    dynamic var createDate: Date = Date()
    dynamic var title: String? = nil
    dynamic var urlStr: String? = nil
    dynamic var pageNumber: Int = 0
    dynamic var offsetX: CGFloat = 0
    dynamic var offsetY: CGFloat = 0
    
    override class func primaryKey() -> String? { return "id" }
    
    convenience init(url: URL) {
        self.init()
        self.title = url.deletingPathExtension().lastPathComponent
        self.urlStr = url.absoluteString
    }
    
    var url: URL? {
        if let urlStr = self.urlStr {
            return URL(string: urlStr)
        } else {
            return nil
        }
    }
}

// CRUD
extension OrzPDFInfo {

    // Read First PDF Info
    class func first() -> OrzPDFInfo? {
        return OrzPDFInfo.all().first
    }
    
    // Read
    class func all() -> Results<OrzPDFInfo> {
        let realm = try! Realm()
        return realm.objects(OrzPDFInfo.self)
    }
    
    // Create
    func save() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    // Delete
    func delete() {
        
        if let url = self.url {
            try? FileManager.default.removeItem(at:url)
        }
        
        let realm = try! Realm()
        try! realm.write {

            realm.delete(self)
        }
    }
    
    func saveProcess(pageNum: Int, offsetX: CGFloat, offsetY: CGFloat) {
        let realm = try! Realm()
        try! realm.write {
            self.pageNumber = pageNum
            self.offsetX = offsetX
            self.offsetY = offsetY
        }
    }
}
