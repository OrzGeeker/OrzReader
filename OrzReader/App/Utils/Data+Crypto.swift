//
//  Data+Cryto.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/19.
//

import CryptoKit
import Foundation

extension Data {
    var sha256: String {
        SHA256
            .hash(data: self)
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}
