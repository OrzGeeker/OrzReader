//
//  OrzPDFInfo.swift
//  OrzReader
//
//  Created by joker on 2019/2/8.
//  Copyright © 2019 joker. All rights reserved.
//

import RealmSwift
import CryptoSwift

@objcMembers class OrzPDFInfo: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var createDate: Date = Date()
    dynamic var title: String? = nil
    dynamic var urlStr: String? = nil
    dynamic var sha1: String? = nil
    dynamic var contentOffsetX: CGFloat = 0
    dynamic var contentOffsetY: CGFloat = 0
    dynamic var pageMode: Int = 0
    private dynamic var pdfData: Data? = nil
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["pdfData"]
    }
    
    convenience init?(url: URL) {
        
        guard url.scheme == "file", url.pathExtension == "pdf" else {
            return nil
        }
        
        self.init()
        self.urlStr = url.absoluteString
        self.title = url.deletingPathExtension().lastPathComponent
        self.pdfData = try? Data(contentsOf: url)
        self.sha1 = self.pdfData?.sha1().toHexString()
    }
    
    private var pdfUrl: URL? {
        if let documents_url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let sha1 = self.sha1 {
            return documents_url.appendingPathComponent(sha1)
        }
        return nil
    }
    
    func saveToDocuments() {
        guard let pdfUrl = self.pdfUrl else {
            return
        }
        try? self.pdfData?.write(to: pdfUrl)
    }
    
    func removeFromDocuments() {
        guard let pdfUrl = self.pdfUrl else {
            return
        }
        try? FileManager.default.removeItem(at:pdfUrl)
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
        
        guard (self.sha1 != nil) && self.sha1!.count > 0 else {
            return
        }
        
        let exists = OrzPDFInfo.all().filter("sha1 = '\(self.sha1!)'")
        
        if exists.count == 0 {
            try! realm.write {
                // 保存PDF文件到Documents档中
                self.saveToDocuments()
                self.urlStr = self.pdfUrl?.absoluteString
                realm.add(self)
            }
        }
    }
    
    // Delete
    func delete() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
            self.removeFromDocuments()
        }
    }
    
    func saveProcess(_ contentOffset: CGPoint, _ pageMode: Int) {
        let realm = try! Realm()
        try! realm.write {
            self.contentOffsetX = contentOffset.x
            self.contentOffsetY = contentOffset.y
            self.pageMode = pageMode
        }
    }
}
