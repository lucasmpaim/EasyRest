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
    
    public func requestInterceptor<T: JsonConvertibleType>(api: API<T>) {}
    
    public func responseInterceptor<T: JsonConvertibleType>(api: API<T>, response: Alamofire.Response<AnyObject, NSError>) {
        if Utils.isSuccessfulRequest(response) {
            if let curl = api.curl {
                api.logger?.info(curl)
            }
        } else {
            if let curl = api.curl {
                api.logger?.error(curl)
            }
        }
    }
    
}