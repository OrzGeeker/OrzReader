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

    let pdfInfo: OrzPDFInfo

    var body: some View {
        GeometryReader { proxy in
            VStack {
                OrzPDFView(pdfInfo: pdfInfo, scaleFactor: proxy.size.width / pdfInfo.mediaBoxSize.width)
            }
            .toolbar {
                Button(
                    action: {
                        pdfInfo.pageMode.toggle()
                    },
                    label: {
                        Text(pdfInfo.pageMode.title)
                            .bold().frame(width: 50)
                    }
                )
            }
        }
    }
}

#Preview {
    OrzPDFDetailView(pdfInfo: mockPDF)
}
