import Foundation

let mockPDF = OrzPDFInfo.parse(
    with: Bundle.main.url(
        forResource: "thumbnail",
        withExtension: "png"
    )!
)!

let mockPDFList = [
    mockPDF,
    mockPDF,
    mockPDF,
    mockPDF,
    mockPDF,
    mockPDF,
]
