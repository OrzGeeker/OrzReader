//
//  OrzConfigManager.swift
//  OrzReader
//
//  Created by joker on 2019/2/11.
//  Copyright © 2019 joker. All rights reserved.
//

import Foundation

class OrzConfigManager {
    
    var supportedInterfaceOrientations: UIInterfaceOrientationMask = .allButUpsideDown
    
    static let shared = OrzConfigManager()
    
    private init() {}
}

