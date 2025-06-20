//
//  OrzPDFStore.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/8.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import Logging
import SwiftData
import SwiftUI

@Observable
final class OrzPDFStore {
}

extension OrzPDFStore {
    func importPDF(with url: URL) async {
        logger.info("receive flle url: \(url)")
        guard let pdfInfo = try? await OrzPDFInfo.parse(with: url)
        else {
            return
        }
        sharedModelContainer.mainContext.insert(pdfInfo)
    }
}
