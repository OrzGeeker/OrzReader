import SwiftData
import SwiftUI
internal import UniformTypeIdentifiers

@main
struct OrzReaderApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var onDropIsTargeted: Bool = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { importPDF(with: $0) }
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
