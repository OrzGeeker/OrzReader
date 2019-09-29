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
//                .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
                .navigationBarTitle("上次阅读第\(pdfInfo.lastPageNumber)页", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.pdfStore.contentMode.toggle()
                }, label: { Text(self.pdfStore.contentMode.title) }))
                .onAppear {
                    self.pdfStore.contentMode = .aspectFit
                    self.pdfStore.loadPublisher.send(true)
            }.onDisappear {
                self.pdfStore.savePublisher.send(true)
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
