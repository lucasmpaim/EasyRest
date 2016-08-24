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

public class APIBuilder <T: JsonConvertibleType> {
    
    var path: String
    var queryParams: [String: String]?
    var pathParams: [String: String]?
    var bodyParams: [String: AnyObject]?
    var headers: [String: String]?
    var method: Alamofire.Method?
    
    var logger: Logger?
    
    var interceptors: [Interceptor] = []
    
    let defaultInterceptors: [Interceptor.Type] = [
        CurlInterceptor.self,
        LoggerInterceptor.self
    ]
    
    public init(basePath: String) {
        self.path = basePath
    }
    
    public init() {
        self.path = "" //Constante
    }
    
    public func resource(resourcePath: String, method: Alamofire.Method) -> Self {
        self.path.appendContentsOf(resourcePath)
        self.method = method
        return self
    }
    
    public func addInterceptor(interceptor: Interceptor) -> Self{
        interceptors.append(interceptor)
        return self
    }
    
    public func addInterceptors(interceptors: [Interceptor]) -> Self{
        for interceptor in interceptors {
            self.interceptors.append(interceptor)
        }
        return self
    }
    
    public func logger(logger: Logger) -> Self{
        self.logger = logger
        return self
    }
    
    public func addQueryParams(queryParams : [String: String]) ->  Self {
        if self.queryParams == nil{
            self.queryParams = queryParams
            return self
        }
        
        for (key, value) in queryParams {
            self.queryParams![key] = value
        }
        
        return self
    }
    
    public func addHeaders(headers: [String: String]) -> Self{
        if self.headers == nil{
            self.headers = headers
            return self
        }
        
        for (key, value) in headers {
            self.headers![key] = value
        }
        return self
    }
    
    public func addParameteres(parameters: [ParametersType : AnyObject]) throws {
        
        for (type, obj) in parameters {
            
            let params: [String: AnyObject] = try convertParameters(obj)
            
            switch type {
            case .Body:
                addBodyParameters(params)
            case .Path:
                self.pathParams = params as? [String: String]
            case .Query:
                if let queryParameters = params as? [String: String] {
                    addQueryParams(queryParameters)
                }
            }
            
        }
    }
    
    public func addBodyParameters(bodyParam bodyParam: MappableBase) throws -> Self {
        bodyParams = try bodyParam.jsonRepresentation().foundationDictionary
        return self
    }
    
    public func addBodyParameters(bodyParams : [String: AnyObject]) ->  Self {
        if self.bodyParams == nil{
            self.bodyParams = bodyParams
            return self
        }
        
        for (key, value) in bodyParams {
            self.bodyParams![key] = value
        }
        return self
    }
    
    public func build() -> API<T> {
        
        assert(method != nil, "method not can be empty")
        
        if let pathParams = self.pathParams {
            self.path = self.path.replacePathLabels(pathParams)
        }
        
        let path = NSURL(string: self.path)
        assert(path?.scheme != nil && path?.host != nil, "Invalid URL: \(self.path)")
        
        for interceptorType in defaultInterceptors.reverse() {
            self.interceptors.insert(interceptorType.init(), atIndex: 0)
        }
        
        let api = API<T>(path: path!, method: self.method!, queryParams: queryParams, bodyParams: bodyParams, headers: headers, interceptors: self.interceptors)
        api.logger = self.logger
        return api
    }
    
    public func convertParameters(obj: AnyObject) throws -> [String: AnyObject]{
        if let _obj = obj as? [String: AnyObject] {
            return _obj
        }else if let _obj = obj as? MappableBase {
            return try _obj.jsonRepresentation().foundationDictionary!
        }
        throw RestError(rawValue: RestErrorType.InvalidType.rawValue)
    }
    
}