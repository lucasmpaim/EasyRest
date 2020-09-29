//
//  Interceptors.swift
//  RestClient
//
//  Created by Guizion Labs on 11/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire

public protocol Interceptor{
    
    init()
    
    func requestInterceptor<T: Codable>(_ api: API<T>)
    func responseInterceptor<T: Codable, U>(_ api: API<T>, response: DataResponse<U>)
}
