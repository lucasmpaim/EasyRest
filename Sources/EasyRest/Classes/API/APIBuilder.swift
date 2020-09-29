//
//  APIBuilder.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire

open class APIBuilder <T> where T: Codable {
    
    var path: String
    var queryParams: [String: String]?
    var pathParams: [String: Any]?
    var bodyParams: [String: Any]?
    var headers: [String: String]?
    var method: HTTPMethod?
    var cancelToken: CancelationToken<T>?
    var logger: Loggable?
    
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
    
    open func resource(_ resourcePath: String, method: HTTPMethod) -> Self {
        self.path.append(resourcePath)
        self.method = method
        return self
    }
    
    open func cancelToken(token: CancelationToken<T>) -> Self {
        cancelToken = token
        return self
    }
    
    open func addInterceptor(_ interceptor: Interceptor) -> Self {
        interceptors.append(interceptor)
        return self
    }
    
    open func addInterceptors(_ interceptors: [Interceptor]) -> Self {
        for interceptor in interceptors {
            self.interceptors.append(interceptor)
        }
        return self
    }
    
    open func logger(_ logger: Logger) -> Self {
        self.logger = logger
        return self
    }
    
    open func addQueryParams(_ queryParams : [String: CustomStringConvertible?]) ->  Self {
        if self.queryParams == nil {
            self.queryParams = [:]            
        }
        
        queryParams.forEach {
            if let value = $1 {
                self.queryParams![$0] = "\(value)"
            }
        }
        
        return self
    }
    
    open func addHeaders(_ headers: [String: String]) -> Self{
        if self.headers == nil {
            self.headers = headers
            return self
        }
        
        for (key, value) in headers {
            self.headers![key] = value
        }
        return self
    }
    
    open func addParameteres(_ parameters: [ParametersType : Any?]) throws {
        for (type, obj) in parameters {
            let params = try convertParameters(obj)
            
            switch type {
            case .body, .multiPart:
                _ = addBodyParameters(params)
            case .path:
                self.pathParams = params
            case .query:
                if let queryParameters = params as? [String: String] {
                    _ = addQueryParams(queryParameters)
                }
            case .header:
                guard let headers = params as? [String: String] else { return }
                _ = self.addHeaders(headers)
            }
        }
    }
    
    open func addBodyParameters<T: Encodable>(bodyParam: T) -> Self {
        bodyParams = bodyParam.dictionary
        return self
    }
    
    open func addBodyParameters(_ bodyParams : [String: Any]) ->  Self {
        if self.bodyParams == nil{
            self.bodyParams = bodyParams
            return self
        }
        
        for (key, value) in bodyParams {
            self.bodyParams![key] = value
        }
        return self
    }
    
    open func build() -> API<T> {
        
        assert(method != nil, "method not can be empty")
        
        if let pathParams = self.pathParams {
            self.path = self.path.replacePathLabels(pathParams)
        }
        
        let path = URL(string: self.path)
        assert(path?.scheme != nil && path?.host != nil, "Invalid URL: \(self.path)")
        
        for interceptorType in defaultInterceptors.reversed() {
            self.interceptors.insert(interceptorType.init(), at: 0)
        }
        
        let api = API<T>(path: path!, method: self.method!, queryParams: queryParams, bodyParams: bodyParams, headers: headers, interceptors: self.interceptors, cancelToken: cancelToken)
        api.logger = self.logger
        return api
    }
    
    open func convertParameters(_ obj: Any?) throws -> [String: Any]{
        if let _obj = obj as? [String: AnyObject] {
            return _obj
        } else if let _obj = obj as? Encodable {
            return _obj.dictionary!
        }
        throw RestError(rawValue: RestErrorType.invalidType.rawValue)
    }
    
}
