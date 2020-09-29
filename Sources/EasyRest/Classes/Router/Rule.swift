//
//  Rule.swift
//  RestClient
//
//  Created by Guizion Labs on 22/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire

open class Rule {
    public let isAuthenticable: Bool
    let path: String
    let method: HTTPMethod
    var parameters: [ParametersType: Any?]
    
    public init(method: HTTPMethod, path: String, isAuthenticable: Bool, parameters: [ParametersType: Any?]) {
        self.isAuthenticable = isAuthenticable
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}
