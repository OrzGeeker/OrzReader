import SwiftData
import SwiftUI

struct OrzPDFListView: View {
    let pdfs: [OrzPDFInfo]
    @Binding var selectedPDF: OrzPDFInfo?
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        if pdfs.isEmpty {
            VStack {
                Text("暂无PDF导入")
                    .fontWeight(.bold)
                    .font(.system(.largeTitle))
                Text("通过AriDrop传送到本App打开PDF文件")
                    .font(.system(.subheadline))
                    .padding([.top, .leading, .trailing], 20)
                    .foregroundColor(.gray)
                Text("通过其它应用分享到本App打开PDF文件")
                    .font(.system(.subheadline))
                    .padding(.top, 10)
                    .foregroundColor(.gray)
            }
        } else {
            List(selection: $selectedPDF) {
                ForEach(pdfs) { pdfInfo in
                    NavigationLink(value: pdfInfo) {
                        OrzPDFListRow(pdfInfo: pdfInfo)
                            .frame(height: 100)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let pdfInfo = pdfs[index]
                pdfInfo.removeFromDocument()
                modelContext.delete(pdfInfo)
            }
        }
    }
}

#Preview("Empty List") {
    OrzPDFListView(pdfs: [], selectedPDF: .constant(nil))
}

#Preview("One PDF") {
    OrzPDFListView(
        pdfs: [mockPDF],
        selectedPDF: .constant(nil)
    )
}

#Preview("PDF List") {
    OrzPDFListView(
        pdfs: mockPDFList,
        selectedPDF: .constant(nil)
    )
}
