//
//  OrzPDFStore.swift
//  OrzReader
//
//  Created by wangzhizhou on 2019/9/8.
//  Copyright © 2019 wangzhizhou. All rights reserved.
//

import SwiftUI
import RealmSwift
import Combine

final class OrzPDFStore: ObservableObject {
    @Published var pdfs = OrzPDFInfo.all()
    @Published var progress: Float = 0
    @Published var contentMode: OrzPDFPageContentMode = .aspectFit
    
    let savePublisher = PassthroughSubject<Any, Never>()
    let loadPublisher = PassthroughSubject<Any, Never>()
    let goToPage = PassthroughSubject<Any, Never>()
    
    var notificationToken: NotificationToken? = nil

    init() {
        notificationToken =  OrzPDFInfo.all().observe { (changes) in
            switch changes {
            case .initial(let pdfs):
                self.pdfs = pdfs
            case .update(let pdfs, _ ,  _,  _):
                self.pdfs = pdfs
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
