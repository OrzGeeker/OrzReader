//
//  OrzReaderApp.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/19.
//

import SwiftData
import SwiftUI

@main
struct OrzReaderApp: App {
    @State private var store = OrzPDFStore()
    var body: some Scene {
        WindowGroup {
            OrzPDFListView()
                .environment(store)
                .onOpenURL { store.importPDF(with: $0) }
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
    @Environment(\.scenePhase) var scenePhase
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
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
}
