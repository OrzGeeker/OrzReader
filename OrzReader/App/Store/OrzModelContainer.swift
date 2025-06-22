import Foundation
import Logging
import SwiftData

/// SwiftData 数据存储容器
let sharedModelContainer: ModelContainer = {
    // 调试选项
    destroyPersistentStore()
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

/// 通过url导入PDF文件到应用
/// - Parameter url: pdf文件url
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

/// 彻底销毁SwiftData存储文件
///
/// 根据环境变量 RESET_SWIFTDATA = 1 来命中逻辑，仅开发环境使用
func destroyPersistentStore() {
    #if DEBUG
        guard ProcessInfo.processInfo.environment["RESET_SWIFTDATA"] == "1"
        else {
            return
        }
        let storeURL = URL.applicationSupportDirectory.appending(
            path: "default.store"
        )
        // 删除主文件及关联文件
        let shmURL = storeURL.appendingPathExtension("shm")
        let walURL = storeURL.appendingPathExtension("wal")
        [storeURL, shmURL, walURL].forEach { url in
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    #endif
}
