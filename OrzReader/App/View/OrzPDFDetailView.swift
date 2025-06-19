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

    @Environment(OrzPDFStore.self) var pdfStore

    @State var loadLastReadPage: Bool = false

    var pdfInfo: OrzPDFInfo

    var body: some View {
        VStack {
            OrzPDFProgressView(progress: pdfStore.progress)
            OrzPDFView(pdfInfo: pdfInfo, loadLastReadPage: loadLastReadPage)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            self.pdfStore.contentMode.toggle()
                        },
                        label: {
                            Text(self.pdfStore.contentMode.title)
                                .bold().frame(width: 50)
                        }
                    )
                ).onAppear(perform: {
                    self.loadLastReadPage = true
                })
                .onDisappear {
                    // TODO: 保存进度
                    self.pdfStore.contentMode = .aspectFit
                }.padding(.top, -8)

        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
