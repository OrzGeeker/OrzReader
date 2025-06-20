import PDFKit
import SwiftData

@Model
final class OrzPDFInfo: Identifiable {
    var title: String
    var sha256: String
    var urlStr: String
    var pageCount: Int
    var thumbnail: Data
    var pdfUrl: URL
    enum OrzPDFPageContentMode: String, Codable {
        case aspectFit = "Fit"
        case aspectFill = "Fill"
        mutating func toggle() {
            switch self {
            case .aspectFit:
                self = .aspectFill
            case .aspectFill:
                self = .aspectFit
            }
        }
        var title: String {
            self.rawValue
        }
    }
    var pageMode: OrzPDFPageContentMode
    var lastPageNumber: Int
    var lastPagePointX: Float
    var lastPagePointY: Float
    var lastPageZoom: Float
    var progress: Float
    init(
        title: String,
        sha256: String,
        urlStr: String,
        pageCount: Int,
        thumbnail: Data,
        pdfUrl: URL,
        pageMode: OrzPDFPageContentMode = .aspectFit,
        lastPageNumber: Int = 1,
        lastPagePointX: Float = 0,
        lastPagePointY: Float = 0,
        lastPageZoom: Float = 0,
        progress: Float = 0
    ) {
        self.title = title
        self.sha256 = sha256
        self.urlStr = urlStr
        self.pageCount = pageCount
        self.thumbnail = thumbnail
        self.pdfUrl = pdfUrl
        self.pageMode = pageMode
        self.lastPageNumber = lastPageNumber
        self.lastPagePointX = lastPagePointX
        self.lastPagePointY = lastPagePointY
        self.lastPageZoom = lastPageZoom
        self.progress = progress
    }
}
extension OrzPDFInfo {
    static func parse(with url: URL) async throws -> OrzPDFInfo? {
        guard
            url.scheme == "file", url.pathExtension == "pdf",
            let data = try? Data(contentsOf: url),
            let document = PDFDocument(data: data),
            let page = document.page(at: 0),
            let thumbnailData = page.thumbnail(
                of: page.bounds(for: .mediaBox).size,
                for: .mediaBox
            ).pngData(),
            let documents_url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        else {
            return nil
        }

        let pdfInfo = OrzPDFInfo(
            title: url.deletingPathExtension().lastPathComponent,
            sha256: data.sha256,
            urlStr: url.absoluteString,
            pageCount: document.pageCount,
            thumbnail: thumbnailData,
            pdfUrl: documents_url.appendingPathComponent(data.sha256),
        )
        try data.write(to: pdfInfo.pdfUrl)
        return pdfInfo
    }

    func removeFromDocuments() {
        try? FileManager.default.removeItem(at: pdfUrl)
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
