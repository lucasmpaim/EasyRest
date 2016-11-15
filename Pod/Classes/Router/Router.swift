//
//  Router.swift
//  RestClient
//
//  Created by Guizion Labs on 16/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import Alamofire


public protocol Routable {
    var rule: Rule { get }
}

extension Routable {
    
    public func builder<T: NodeConvertible>(_ base: String, type: T.Type) throws -> APIBuilder<T> {
        let builder = APIBuilder<T>()
        
        builder.logger = Logger()
        
        try builder.addParameteres(self.rule.parameters)
        return builder.resource(base + self.rule.path, method: self.rule.method)
    }
    
    public func builder<T: NodeConvertible, A: Authentication>(_ base: String, type: T.Type, authInterceptor: A?) throws -> APIBuilder<T> {
        
        if self.rule.isAuthenticable && authInterceptor?.validToken() != true {
            throw RestError(rawValue: RestErrorType.authenticationRequired.rawValue)
        }
        
        let builder = APIBuilder<T>()
        if let auth = authInterceptor {
            _ = builder.addInterceptor(auth.interceptor)
        }
        
        builder.logger = Logger()
        
        try builder.addParameteres(self.rule.parameters)
        return builder.resource(base + self.rule.path, method: self.rule.method)
    }
    
}
