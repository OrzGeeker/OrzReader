//
//  OrzPDFStore.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/8.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI

final class OrzPDFStore: ObservableObject {
    @Published var pdfs = OrzPDFInfo.all()
}
