//
//  NSImage+.swift
//  OrzReader
//
//  Created by wangzhizhou on 2025/6/21.
//

#if canImport(AppKit)
    import AppKit

    extension NSImage {
        func pngData() -> Data? {
            guard let tiffData = tiffRepresentation,
                let bitmapRep = NSBitmapImageRep(data: tiffData)
            else {
                return nil
            }
            return bitmapRep.representation(using: .png, properties: [:])
        }
    }
#endif
