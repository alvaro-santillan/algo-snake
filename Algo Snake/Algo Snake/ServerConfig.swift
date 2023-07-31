//
//  ServerConfig.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/30/23.
//  Copyright © 2023 Álvaro Santillan. All rights reserved.
//

import Foundation

enum BaseUrl: String {
    case LOCAL = "https:\\xyz-local.com"
    case QA = "https:\\xyz-qa.com"
    case PROD = "https:\\xyz-prod.com"
    case DEMO = "https:\\xyz-demo.com"
    case DEV = "https:\\xyz-dev.com"
}

class ServerConfig {
    static let shared: ServerConfig = ServerConfig()
    
    var baseUrl: String?
    
    func setUpServerConfig() {
        #if LOCAL
        self.baseUrl = BaseUrl.LOCAL.rawValue
        #elseif QA
        self.baseUrl = BaseUrl.QA.rawValue
        #elseif PROD
        self.baseUrl = BaseUrl.PROD.rawValue
        #elseif DEMO
        self.baseUrl = BaseUrl.DEMO.rawValue
        #elseif DEV
        self.baseUrl = BaseUrl.DEV.rawValue
        #endif
    }
}
