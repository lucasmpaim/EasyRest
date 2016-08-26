//
//  API.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer
import Alamofire

public class API <T: JsonConvertibleType> {
        
    public var path: NSURLRequest
    public var queryParams: [String: String]?
    public var bodyParams: [String: AnyObject]?
    public var method: Alamofire.Method
    public var headers: [String: String] = [:]
    public var interceptors: [Interceptor] = []
    public var logger: Logger?
    public var curl: String?
    
    public init(path: NSURL, method: Alamofire.Method, queryParams: [String: String]?, bodyParams: [String: AnyObject]?, headers: [String: String]?, interceptors: [Interceptor]?){
        
        self.path = NSURLRequest(URL: path)

        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.method = method
        if headers != nil {
            self.headers = headers!
        }
        if interceptors != nil {self.interceptors.appendContentsOf(interceptors!)}
    }
    
    
    public func execute( onSuccess: (result: T?) -> Void, onError: (RestError?) -> Void, always: () -> Void) {
        
        for interceptor in interceptors {
            interceptor.requestInterceptor(self)
        }

        if queryParams != nil {
            self.path = ParameterEncoding.URLEncodedInURL.encode(self.path, parameters: queryParams).0
        }
        
        let request = Alamofire.request(method, path.URLString, parameters: bodyParams, encoding: ParameterEncoding.JSON, headers: headers)
        self.curl = request.debugDescription
        
        request.responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            for interceptor in self.interceptors {
                interceptor.responseInterceptor(self, response: response)
            }
            
            if Utils.isSuccessfulRequest(response) {
                var instance: T? = nil // For empty results
                if let _ = response.result.value {
                    let json = try! Json.deserialize(response.data!)
                    instance = try! T.newInstance(json, context: EmptyJson)
                }
                onSuccess(result: instance)
            } else {
                let error = RestError(rawValue: response.response?.statusCode ?? RestErrorType.Unknow.rawValue,
                        rawIsHttpCode: true,
                        rawResponse: response.result.value)
                onError(error)
            }
            
            always()
        }
    }
    
}


extension Array: JsonConvertibleType{
    public static func newInstance(json: Json, context: Context) throws -> Array {
        return []
    }
    public func jsonRepresentation() throws -> Json {
        fatalError("Error type!")
    }
}