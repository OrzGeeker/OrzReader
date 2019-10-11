//
//  OrzPDFListView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/5.
//  Copyright © 2019 wangzhizhou. All rights reservxed.
//

import SwiftUI

struct OrzPDFListView: View {
    
    @EnvironmentObject var pdfStore: OrzPDFStore
    
    var body: some View {
        
        VStack {
            if pdfStore.pdfs.count > 0 {
                NavigationView {
                    List(pdfStore.pdfs) { pdfInfo in
                        NavigationLink(destination: OrzPDFDetailView(pdfInfo: pdfInfo)) {
                            OrzPDFListRow(pdfInfo: pdfInfo)
                        }
                    }
                    .navigationBarTitle("图书列表", displayMode: .large)
                }
            } else {
                Text("暂无PDF导入")
                    .fontWeight(.bold)
                    .font(.system(.largeTitle))
            }
        }
    }
}
