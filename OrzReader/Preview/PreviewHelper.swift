import Foundation

let mockPDF = OrzPDFInfo.parse(
    with: Bundle.main.url(
        forResource: "normal",
        withExtension: "pdf"
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
