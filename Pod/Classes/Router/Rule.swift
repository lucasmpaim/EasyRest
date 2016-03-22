//
//  Rule.swift
//  RestClient
//
//  Created by Guizion Labs on 22/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire

class Rule {
    let isAuthenticable: Bool
    let path: String
    let method: Alamofire.Method
    let parameters: [ParametersType:  AnyObject]
    
    init(method: Alamofire.Method, path: String, isAuthenticable: Bool, parameters: [ParametersType:  AnyObject]){
        self.isAuthenticable = isAuthenticable
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}