//
//  OrzPDFDetailView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/6.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI

struct OrzPDFDetailView: View {
    
    @State var pdfInfo: OrzPDFInfo
    @State var hideStatusBar: Bool = false
    @State var contentMode: OrzPDFPageContentMode = .aspectFit
    var body: some View {
        OrzPDFView(pdfInfo: pdfInfo, contentMode: $contentMode)
            .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.contentMode.toggle()
            }, label: { Text(self.contentMode.title) }))
            .edgesIgnoringSafeArea([.horizontal, .bottom])
            .statusBar(hidden: hideStatusBar)
    }
}
