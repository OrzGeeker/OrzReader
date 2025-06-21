//
//  Logger.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/20.
//

import Logging

let logger = {
    var ret = Logger(label: "OrzReader")
    #if DEBUG
        ret.logLevel = .debug
    #else
        ret.logLevel = .info
    #endif
    return ret
}()
