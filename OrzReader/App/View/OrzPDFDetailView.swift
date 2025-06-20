//
//  OrzPDFDetailView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/6.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import Combine
import SwiftUI

struct OrzPDFDetailView: View {

    @State var loadLastReadPage: Bool = false

    var pdfInfo: OrzPDFInfo

    var body: some View {
        VStack {
            OrzPDFProgressView(progress: pdfInfo.progress)
            OrzPDFView(pdfInfo: pdfInfo, loadLastReadPage: loadLastReadPage)
                .navigationTitle("")
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            pdfInfo.pageMode.toggle()
                        },
                        label: {
                            Text(pdfInfo.pageMode.title)
                                .bold().frame(width: 50)
                        }
                    )
                ).onAppear(perform: {
                    self.loadLastReadPage = true
                })
                .onDisappear {
                    // TODO: 保存进度
                }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
