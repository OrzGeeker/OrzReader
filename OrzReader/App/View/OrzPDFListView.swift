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
            NavigationView {
                List(pdfStore.pdfs) { pdfInfo in
                    NavigationLink(destination: OrzPDFDetailView(pdfInfo: pdfInfo)) {
                        Text("\(pdfInfo.title!)")
                    }
                }
                .navigationBarTitle("图书列表")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrzPDFListView()
    }
}
