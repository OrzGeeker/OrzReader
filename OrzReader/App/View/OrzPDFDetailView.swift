//
//  OrzPDFDetailView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/6.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI
import Combine

struct OrzPDFDetailView: View {
    
    @State var pdfInfo: OrzPDFInfo
    @State var contentMode: OrzPDFPageContentMode = .aspectFit
    @State var progress: Float = 0
    
    var body: some View {
        VStack {
            OrzPDFProgressView(progress: progress)
            OrzPDFView(pdfInfo: pdfInfo, contentMode: contentMode, progress: $progress)
                .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.contentMode.toggle()
                }, label: { Text(self.contentMode.title) }))
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
