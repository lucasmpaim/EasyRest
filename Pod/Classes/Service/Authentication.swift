//
//  AuthenticationService.swift
//  RestClient
//
//  Created by Guizion Labs on 14/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire
import Genome



public protocol HasToken {
    func getToken() -> String?
    func validToken() -> Bool
}

public extension HasToken {
    func validToken() -> Bool {
        return getToken() != nil
    }
}


public protocol Authentication : HasToken{
    associatedtype tokenType: MappableBase
    
    var interceptor: AuthenticatorInterceptor {get}
    
    init()
    func saveToken(obj: tokenType)
}


public protocol AuthenticatorInterceptor : Interceptor{
    var token: HasToken {get}
}

public extension AuthenticatorInterceptor{
    
    public func requestInterceptor<T: JsonConvertibleType>(api: API<T>) {
        if let token = token.getToken() {
            api.headers["Authorization"] = token
        }
    }
    
    public func responseInterceptor<T: JsonConvertibleType>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        
    }
    
}
