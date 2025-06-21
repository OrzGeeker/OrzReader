import Logging
import PDFKit
import SwiftData

@Model
final class OrzPDFInfo {
    @Attribute(.unique)
    var title: String
    var sha256: String
    var pageCount: Int
    var thumbnail: Data
    struct MediaBoxSize: Codable {
        let width: Double
        let height: Double
    }
    var mediaBoxSize: MediaBoxSize
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
        pageCount: Int,
        thumbnail: Data,
        mediaBoxSize: MediaBoxSize,
        pageMode: OrzPDFPageContentMode = .aspectFit,
        lastPageNumber: Int = 1,
        lastPagePointX: Float = 0,
        lastPagePointY: Float = 0,
        lastPageZoom: Float = 0,
        progress: Float = 0
    ) {
        self.title = title
        self.sha256 = sha256
        self.pageCount = pageCount
        self.thumbnail = thumbnail
        self.mediaBoxSize = mediaBoxSize
        self.pageMode = pageMode
        self.lastPageNumber = lastPageNumber
        self.lastPagePointX = lastPagePointX
        self.lastPagePointY = lastPagePointY
        self.lastPageZoom = lastPageZoom
        self.progress = progress
    }
}
extension OrzPDFInfo {
    static func parse(with url: URL) -> OrzPDFInfo? {
        guard
            url.isFileURL, url.pathExtension == "pdf",
            let data = try? Data(contentsOf: url),
            let document = PDFDocument(data: data),
            let page = document.page(at: 0),
            let thumbnailData = page.thumbnail(
                of: page.bounds(for: .mediaBox).size,
                for: .mediaBox
            ).pngData()
        else {
            return nil
        }

        let size = page.bounds(for: .mediaBox).size
        let mediaBoxSize = MediaBoxSize(width: size.width, height: size.height)
        let pdfInfo = OrzPDFInfo(
            title: url.deletingPathExtension().lastPathComponent,
            sha256: data.sha256,
            pageCount: document.pageCount,
            thumbnail: thumbnailData,
            mediaBoxSize: mediaBoxSize,
        )
        do {
            try data.write(to: pdfInfo.fileUrl)
            logger.debug("write: \(pdfInfo.fileUrl)")
            return pdfInfo
        } catch {
            try? FileManager.default.removeItem(at: pdfInfo.fileUrl)
            return nil
        }
    }
    func removeFromDocument() {
        logger.debug("remove: \(fileUrl)")
        try? FileManager.default.removeItem(at: fileUrl)
    }
    static private let documents_url = try! FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    )
    var fileUrl: URL {
        OrzPDFInfo.documents_url.appendingPathComponent(title)
    }
}
