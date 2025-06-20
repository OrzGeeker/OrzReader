import SwiftData
import SwiftUI

@main
struct OrzReaderApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var store = OrzPDFStore()
    var body: some Scene {
        WindowGroup {
            OrzPDFListView()
                .environment(store)
                .onOpenURL { url in
                    Task {
                        await store.importPDF(with: url)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .inactive:
                // TODO: 保存阅读进度
                break
            case .background:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
}
