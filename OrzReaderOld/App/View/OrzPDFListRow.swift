//
//  OrzPDFListRow.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/30.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI

struct OrzPDFListRow: View {
    
    var pdfInfo: OrzPDFInfo
    
    var body: some View {
        HStack {
            if (pdfInfo.uiImage != nil) {
                Image(uiImage: pdfInfo.uiImage!)
                    .resizable()
                    .frame(width: pdfInfo.uiImage!.size.width / pdfInfo.uiImage!.size.height  * 100, height: 100, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            VStack {
                Text("\(pdfInfo.title!)")
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .lineLimit(2)
                Spacer()
                HStack {
                    Text("上次阅读第\(pdfInfo.lastPageNumber)页")
                        .font(.system(size: 12))
                        
                    Spacer()
                }
            }
        }
    }
}
