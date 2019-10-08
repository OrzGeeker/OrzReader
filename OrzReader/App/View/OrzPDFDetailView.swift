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
    
    @State var loadLastReadPage: Bool = false
    
    var pdfInfo: OrzPDFInfo
    
    var body: some View {
        VStack {
            OrzPDFProgressView(progress: pdfStore.progress)
            OrzPDFView(pdfInfo: pdfInfo, loadLastReadPage: loadLastReadPage)
//                .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
                .navigationBarTitle("上次阅读第\(pdfInfo.lastPageNumber)页", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.pdfStore.contentMode.toggle()
                }, label: {
                    Text(self.pdfStore.contentMode.title)
                        .bold().frame(width: 50)
                })).onAppear(perform: {
                    self.loadLastReadPage = true
                })
                .onDisappear {
                    self.pdfStore.savePublisher.send(true)
            }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
