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

open class CurlInterceptor: Interceptor {
    
    required public init() {}
    
    open func requestInterceptor<T: NodeInitializable>(_ api: API<T>) {}
    
    open func responseInterceptor<T: NodeInitializable>(_ api: API<T>, response: DataResponse<Any>) {
        if Utils.isSuccessfulRequest(response: response) {
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
