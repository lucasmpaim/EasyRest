//
//  PostModel.swift
//  EasyRest_Example
//
//  Created by Ráfagan Abreu on 11/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

// EasyRest conforms to Encodable/Codable Swift 4+ standards
// Early versions supported the Genome library (Swift 3)
class PostModel: Codable {
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
    
    // Use that to instantiate without a mandatory decoder
    init() {
        
    }
}

extension PostModel: CustomStringConvertible {
    var description: String {
        return "\(id!), \(userId!), \(title!), \(body!)"
    }
}
