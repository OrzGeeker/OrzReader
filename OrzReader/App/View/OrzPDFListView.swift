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
    @State var showFeedBack: Bool = false
    
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
                    .navigationBarItems(trailing: Button(action: {
                        self.showFeedBack.toggle()
                    }, label: {
                        Text("反馈").font(.system(.headline))
                    }))
                    .sheet(isPresented: $showFeedBack) {
                        OrzFeedBackView()
                    }
                }
            } else {
                Text("暂无PDF导入")
                    .fontWeight(.bold)
                    .font(.system(.largeTitle))
                Text("通过AriDrop传送到本App打开PDF文件")
                    .font(.system(.subheadline))
                    .padding([.top, .leading, .trailing], 20)
                    .foregroundColor(.gray)
                Text("通过其它应用分享到本App打开PDF文件")
                    .font(.system(.subheadline))
                    .padding(.top, 10)
                    .foregroundColor(.gray)
            }
        }
    }
}
