//
//  OrzPDFStore.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/8.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import Logging
import SwiftUI

@Observable
final class OrzPDFStore {
    var pdfs = [OrzPDFInfo]()
    var progress: Float = 0
    var contentMode: OrzPDFPageContentMode = .aspectFit
}
extension OrzPDFStore {
    func importPDF(with url: URL) {
        logger.info("receive flle url: \(url)")
        // TODO: 外部导入的图片保存到数据库中
        guard let pdfInfo = OrzPDFInfo(url: url)
        else {
            return
        }
        pdfs.append(pdfInfo)
        pdfInfo.saveToDocuments()
    }
}
