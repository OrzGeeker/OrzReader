import PDFKit
import SwiftData

@Model
final class OrzPDFInfo {
    var title: String
    var sha256: String
    var urlStr: String
    var pageCount: Int
    var thumbnail: Data
    var fileUrl: URL
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
        fileUrl: URL,
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
        self.fileUrl = fileUrl
        self.pageMode = pageMode
        self.lastPageNumber = lastPageNumber
        self.lastPagePointX = lastPagePointX
        self.lastPagePointY = lastPagePointY
        self.lastPageZoom = lastPageZoom
        self.progress = progress
    }
}
extension OrzPDFInfo {
    static func parse(with url: URL) async -> OrzPDFInfo? {
        guard
            url.isFileURL, url.pathExtension == "pdf",
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
            fileUrl: documents_url.appendingPathComponent(
                url.lastPathComponent
            ),
        )
        do {
            try data.write(to: pdfInfo.fileUrl)
            return pdfInfo
        } catch {
            try? FileManager.default.removeItem(at: pdfInfo.fileUrl)
            return nil
        }
    }
    func removeFromDocument() {
        try? FileManager.default.removeItem(at: fileUrl)
    }
}
