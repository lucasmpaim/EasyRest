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

public protocol Authentication : Interceptor {
    associatedtype tokenType: MappableBase
    
    func getToken() -> String?
    func saveToken(obj: tokenType)
}


public extension Authentication  {
    
    public func requestInterceptor<T: MappableBase>(api: API<T>) {
        if let token = getToken() {
            api.headers["Authorization"] = token
        }
    }
    
    public func responseInterceptor<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        
    }

}