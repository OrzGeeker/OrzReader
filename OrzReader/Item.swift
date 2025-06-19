//
//  Item.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
