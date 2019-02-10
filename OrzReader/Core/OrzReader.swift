//
//  OrzReader.swift
//  OrzReader
//
//  Created by joker on 2019/2/7.
//  Copyright © 2019 joker. All rights reserved.
//

import UIKit

public class OrzReader {
    @discardableResult
    class func openPDF(_ url: URL) -> Bool {
        guard url.scheme == "file", url.pathExtension == "pdf" else { return false }
        OrzPDFInfo(url: url).save()
        return true
    }
}
