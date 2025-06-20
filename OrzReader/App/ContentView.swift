import SwiftData
import SwiftUI

struct ContentView: View {
    @Query private var pdfs: [OrzPDFInfo]
    @State private var selctedPDF: OrzPDFInfo?
    @State private var showFeedBack: Bool = false
    var body: some View {
        NavigationSplitView {
            OrzPDFListView(pdfs: pdfs, selectedPDF: $selctedPDF)
                .toolbar {
                    ToolbarItem {
                        Button(
                            action: {
                                self.showFeedBack.toggle()
                            },
                            label: {
                                Text("反馈").font(.system(.headline))
                            }
                        )
                    }
                }
                .sheet(isPresented: $showFeedBack) {
                    OrzFeedBackView()
                }
                #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                #endif
        } detail: {
            if let selctedPDF {
                OrzPDFDetailView(pdfInfo: selctedPDF)
            } else {
                EmptyView()
            }
        }
    }
}
