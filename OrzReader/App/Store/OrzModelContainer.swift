import Foundation
import Logging
import SwiftData

let sharedModelContainer: ModelContainer = {
    // 调试选项
    if ProcessInfo.processInfo.environment["RESET_SWIFTDATA"] == "1" {
        deleteStoreFiles()
    }
    let schema = Schema([
        OrzPDFInfo.self
    ])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )
    do {
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration],
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

func importPDF(with url: URL) {
    logger.info("import pdf: \(url)")
    Task {
        guard let pdfInfo = OrzPDFInfo.parse(with: url)
        else {
            return
        }
        sharedModelContainer.mainContext.insert(pdfInfo)
    }
}

// 删除存储文件（重置数据库）
private func deleteStoreFiles() {
    let fileManager = FileManager.default
    guard
        let appSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first,
        let bundleID = Bundle.main.bundleIdentifier
    else {
        return
    }

    let storeDirectory = appSupportURL.appendingPathComponent(bundleID)

    do {
        let storeFiles = try fileManager.contentsOfDirectory(
            at: storeDirectory,
            includingPropertiesForKeys: nil
        )

        for file in storeFiles {
            if file.pathExtension == "store"
                || file.pathExtension == "store-shm"
                || file.pathExtension == "store-wal"
            {
                try fileManager.removeItem(at: file)
                logger.debug("🗑️ 已删除存储文件: \(file.lastPathComponent)")
            }
        }
    } catch {
        logger.error("⚠️ 删除存储文件失败: \(error)")
    }
}
