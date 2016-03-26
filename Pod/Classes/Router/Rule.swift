//
//  Rule.swift
//  RestClient
//
//  Created by Guizion Labs on 22/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire
import Genome

public class Rule {
    public let isAuthenticable: Bool
    let path: String
    let method: Alamofire.Method
    let parameters: [ParametersType:  AnyObject]
    public let responseType: JsonConvertibleType.Type?
    
    public init(method: Alamofire.Method, path: String, isAuthenticable: Bool, parameters: [ParametersType:  AnyObject], responseType: JsonConvertibleType.Type){
        self.isAuthenticable = isAuthenticable
        self.path = path
        self.method = method
        self.parameters = parameters
        self.responseType = responseType
    }
}