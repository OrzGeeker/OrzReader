//
//  OrzReaderApp.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/19.
//

import SwiftUI
import SwiftData

@main
struct OrzReaderApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var store = OrzPDFStore()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            OrzPDFListView().environmentObject(store)
        }
        .modelContainer(sharedModelContainer)
//        .onChange(of: scenePhase) { oldValue, newValue in
//            switch newValue {
//            case .active:
//            case .background:
//            case .inactive:
//                store.savePublisher.send(true)
//            @unknown default:
//                break
//            }
//        }
//        .onOpenURL { url in
//            OrzPDFInfo(url: url)?.save()
//        }
    }
    
}
