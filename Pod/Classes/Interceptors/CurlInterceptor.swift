//
//  CurlInterceptor.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import Alamofire

public class CurlInterceptor: Interceptor {
    
    required public init() {}
    
    public func requestInterceptor<T: MappableBase>(api: API<T>) {}
    
    public func responseInterceptor<T: MappableBase>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        if Utils.isSucessRequest(response) {
            api.logger?.info("\(api.curl!)")
        }else{
            api.logger?.error("\(api.curl!)")
        }
    }
    
}