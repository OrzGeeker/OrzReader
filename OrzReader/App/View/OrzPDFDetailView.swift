//
//  OrzPDFDetailView.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/6.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI

struct OrzPDFDetailView: View {
    
    var pdfInfo: OrzPDFInfo

    var body: some View {
        OrzPDFView(pdfInfo: pdfInfo)
            .navigationBarTitle("\(pdfInfo.title ?? "图书详情")", displayMode: .inline)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
