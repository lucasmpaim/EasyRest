//
//  APIBuilder.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer
import Alamofire

class APIBuilder <T: MappableBase> {
    
    var path: String
    var queryParams: [String: String]?
    var bodyParams: [String: AnyObject]?
    var headers: [String: String]?
    var method: Alamofire.Method?
    
    var interceptors: [Interceptor] = []
    
    let defaultInterceptors: [Interceptor.Type] = [
        CurlInterceptor.self,
        LoggerInterceptor.self
    ]
    
    let invalidBody = [
        Alamofire.Method.GET,
    ]
    
    init(basePath: String) {
        self.path = basePath
    }
    
    init() {
        self.path = "" //Constante
    }
    
    func resource(resourcePath: String, method: Alamofire.Method) -> Self {
        self.path.appendContentsOf(resourcePath)
        self.method = method
        return self
    }
    
    func addInsterceptor(interceptor: Interceptor) -> Self{
        interceptors.append(interceptor)
        return self
    }
    
    func addInterceptors(interceptors: [Interceptor]) -> Self{
        for interceptor in interceptors {
            self.interceptors.append(interceptor)
        }
        return self
    }
    
    func addQueryParams(queryParams : [String: String]) ->  Self {
        if self.queryParams == nil{
            self.queryParams = queryParams
            return self
        }
        
        for (key, value) in queryParams {
            self.queryParams![key] = value
        }
        
        return self
    }
    
    func addHeaders(headers: [String: String]) -> Self{
        if self.headers == nil{
            self.headers = headers
            return self
        }
        
        for (key, value) in headers {
            self.headers![key] = value
        }
        return self
    }
    
    func addParameteres(parameters: [ParametersType : [String: String]]) {
        
    }
    
    func addBodyParameters(bodyParam bodyParam: MappableBase) -> Self{
        
        
        do{
            bodyParams = try bodyParam.jsonRepresentation().foundationDictionary
        }catch{
        
        }
        
        return self
    }
    
    func addBodyParameters(bodyParams : [String: AnyObject]) ->  Self {
        if self.bodyParams == nil{
            self.bodyParams = bodyParams
            return self
        }
        
        for (key, value) in bodyParams {
            self.bodyParams![key] = value
        }
        return self
    }
    
    func bodyParameters(bodyParameters: MappableObject) -> Self { return self }
    
    func build() -> API<T> {
        
        assert(method != nil, "method not can be empty")
        
        
        let path = NSURL(string: self.path)
        
        assert(path?.scheme != nil && path?.host != nil, "Invalid URL: \(self.path)")
        
        //assert(invalidBody.indexOf(method!) != nil && bodyParams == nil, "The method \(method!) cannot have a body")
        
        for interceptorType in defaultInterceptors.reverse() {
            self.interceptors.insert(interceptorType.init(), atIndex: 0)
        }
        
        return API<T>(path: path!, method: self.method!, queryParams: queryParams, bodyParams: bodyParams, headers: headers, interceptors: self.interceptors)
    }
    
}