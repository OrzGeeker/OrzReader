//
//  OrzPDFInfo.swift
//  OrzReader
//
//  Created by joker on 2019/2/8.
//  Copyright © 2019 joker. All rights reserved.
//

import CryptoSwift
import PDFKit

enum OrzPDFPageContentMode {
    
    case aspectFit
    case aspectFill
    
    mutating func toggle() {
        switch self {
        case .aspectFit:
            self = .aspectFill
        case .aspectFill:
            self = .aspectFit
        }
    }
    
    var title: String {
        switch self {
        case .aspectFit:
            return "Fill"
        case .aspectFill:
            return "Fit"
        }
    }
}

class OrzPDFInfo: Identifiable {
    
    var id = UUID().uuidString
    var title: String? = nil
    var urlStr: String? = nil
    var sha1: String? = nil
    var pageMode: OrzPDFPageContentMode = .aspectFit
    var lastPageNumber: Int = 1
    var lastPagePointX: Float = 0
    var lastPagePointY: Float = 0
    var lastPageZoom: Float = 0
    var thumbnail: Data? = nil
    var pageCount: Int? = 0
    var pdfUrl: URL? {
        
        if let documents_url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true), let sha1 = self.sha1 {
            return documents_url.appendingPathComponent(sha1)
        }
        return nil
    }
    
    lazy var uiImage: UIImage? = {
        
        guard let thumbnailData = thumbnail, let uiImage = UIImage(data: thumbnailData) else {
            return nil
        }
        return uiImage
    }()
    
    convenience init?(url: URL) {
        
        guard url.scheme == "file", url.pathExtension == "pdf" else {
            return nil
        }
        
        self.init()
    
        if let data = try? Data(contentsOf: url) {
            self.title = url.deletingPathExtension().lastPathComponent
            self.sha1 = data.sha1().toHexString()
            self.urlStr = url.absoluteString
            
            if let document = PDFDocument(data: data), let page = document.page(at: 0) {
                self.pageCount = document.pageCount
                let size = page.bounds(for: .mediaBox).size
                self.thumbnail = page.thumbnail(of: size, for: .mediaBox).pngData()
            }
        }
    }
    
    func saveToDocuments() {
        guard let pdfUrl = self.pdfUrl, let urlStr = self.urlStr else {
            return
        }

        if let url = URL(string: urlStr), let pdfData = try? Data(contentsOf: url) {
            try? pdfData.write(to: pdfUrl)
            self.urlStr = self.pdfUrl?.absoluteString
        }
    }
    
    func removeFromDocuments() {
        guard let pdfUrl = self.pdfUrl else {
            return
        }
        try? FileManager.default.removeItem(at:pdfUrl)
    }
}

//// CRUD
//extension OrzPDFInfo {
//
//    // Read First PDF Info
//    class func first() -> OrzPDFInfo? {
//        return OrzPDFInfo.all().first
//    }
//    
//    // Read
//    class func all() -> Results<OrzPDFInfo> {
//        let realm = try! Realm()
//        return realm.objects(OrzPDFInfo.self)
//    }
//    
//    // Create
//    func save() {
//        
//        let realm = try! Realm()
//        
//        guard (self.sha1 != nil) && self.sha1!.count > 0 else {
//            return
//        }
//        
//        let exists = OrzPDFInfo.all().filter("sha1 = '\(self.sha1!)'")
//        
//        if exists.count == 0 {
//            try! realm.write {
//                // 保存PDF文件到Documents档中
//                self.saveToDocuments()
//                realm.add(self)
//            }
//        }
//    }
//    
//    // Delete
//    func delete() {
//        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.delete(self)
//            self.removeFromDocuments()
//        }
//    }
//    
//    func savePageNumber(_ pageNumber: Int, location point: CGPoint, zoom: CGFloat, pageMode: OrzPDFPageContentMode) {
//        let realm = try! Realm()
//        try! realm.write {
//            self.lastPageNumber = pageNumber
//            self.lastPagePointX = Float(point.x)
//            self.lastPagePointY = Float(point.y)
//            self.lastPageZoom = Float(zoom)
//            self.pageMode = pageMode
//        }
//    }
//}
