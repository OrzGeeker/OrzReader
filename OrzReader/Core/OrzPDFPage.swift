//
//  OrzPDFPage.swift
//  jokerHub
//
//  Created by joker on 2018/5/1.
//  Copyright © 2018年 joker. All rights reserved.
//

import PDFKit

@available(iOS 11.0, *)
class OrzPDFPage: PDFPage {
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        
//        UIGraphicsPushContext(context)
//        context.saveGState()
//        drawBackground(with: UIColor.gray,with: box, to: context)
//        drawWatermark(with: box, to: context, watermark: "jokerhub")
//        context.restoreGState()
//        UIGraphicsPopContext()
        
        super.draw(with: box, to: context)
    }
    
    func drawBackground(with color: UIColor, with box: PDFDisplayBox ,to context: CGContext) {
        let pageBounds = self.bounds(for: box)
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)
        context.addRect(pageBounds);
        context.drawPath(using: .fill)
    }
    
    func drawWatermark(with box:PDFDisplayBox, to context: CGContext, watermark: String) {
        let pageBounds = self.bounds(for: box)
        context.translateBy(x: 0, y: pageBounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat.pi/4.0)
        let string = watermark as NSString
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 64)
        ]
    
        string.draw(at: CGPoint(x: 400, y: 100), withAttributes: attributes)
    }
}
