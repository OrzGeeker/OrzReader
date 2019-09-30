//
//  OrzPDFListRow.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/30.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI

struct OrzPDFListRow: View {
    
    var pdfInfo: OrzPDFInfo
    
    var body: some View {
        Text("\(pdfInfo.title!)")
    }
}
