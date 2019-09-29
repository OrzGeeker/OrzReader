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

    @EnvironmentObject var pdfStore: OrzPDFStore
    
    var pdfInfo: OrzPDFInfo
    
    var body: some View {
        VStack {
            OrzPDFProgressView(progress: pdfStore.progress)
            OrzPDFView(pdfInfo: pdfInfo)
                .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.pdfStore.contentMode.toggle()
                }, label: { Text(self.pdfStore.contentMode.title) }))
                .onAppear {
                    self.pdfStore.contentMode = .aspectFit
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
