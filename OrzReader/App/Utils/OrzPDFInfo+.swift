//
//  OrzPDFInfo+.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/21.
//

import SwiftUI

extension OrzPDFInfo {
    var thumbnailImage: Image? {
        #if os(macOS)
            guard let nsImage = NSImage(data: self.thumbnail)
            else {
                return nil
            }
            return Image(nsImage: nsImage)
        #else
            guard let uiImage = UIImage(data: self.thumbnail)
            else {
                return nil
            }
            return Image(uiImage: uiImage)
        #endif
    }
}
