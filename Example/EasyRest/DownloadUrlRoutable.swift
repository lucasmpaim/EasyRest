//
//  DownloadUrlRoutable.swift
//  EasyRest_Example
//
//  Created by Ráfagan Abreu on 12/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EasyRest

enum DownloadUrlRoutable: Routable {
    case logo
    case bigImage
    
    var rule: Rule {
        switch self {
        case .logo:
            return Rule(
                method: .get,
                path: "https://raw.githubusercontent.com/lucasmpaim/EasyRest/master/Images/logo.png",
                isAuthenticable: false,
                parameters: [:]
            )
        case .bigImage:
            return Rule(
                method: .get,
                path: "https://images8.alphacoders.com/712/712496.jpg",
                isAuthenticable: false,
                parameters: [:]
            )
        }
    }
}
