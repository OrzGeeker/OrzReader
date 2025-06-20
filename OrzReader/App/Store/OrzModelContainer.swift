import Foundation
import Logging
import SwiftData

let sharedModelContainer: ModelContainer = {
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
            configurations: [modelConfiguration]
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

func importPDF(with url: URL) {
    logger.info("import pdf: \(url)")
    Task {
        guard let pdfInfo = await OrzPDFInfo.parse(with: url)
        else {
            return
        }
        sharedModelContainer.mainContext.insert(pdfInfo)
    }
}
