import SwiftUI

struct OrzPDFListRow: View {

    let pdfInfo: OrzPDFInfo

    var body: some View {
        HStack {
            if let thumbnailImage = pdfInfo.thumbnailImage {
                thumbnailImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            }
            VStack(alignment: .leading) {
                Text("\(pdfInfo.title)")
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .lineLimit(2)
                Spacer()
                HStack {
                    Text("上次阅读第\(pdfInfo.lastPageNumber)页")
                        .font(.system(size: 12))

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OrzPDFListRow(pdfInfo: mockPDF)
        .frame(height: 100)
}
