import SwiftUI

struct OrzPDFDetailView: View {

    let pdfInfo: OrzPDFInfo

    var body: some View {
        GeometryReader { proxy in
            VStack {
                OrzPDFView(
                    pdfInfo: pdfInfo,
                    scaleFactor: proxy.size.width / pdfInfo.mediaBoxSize.width
                )
            }
        }
    }
}

#Preview {
    OrzPDFDetailView(pdfInfo: mockPDF)
}
