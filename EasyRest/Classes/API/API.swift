//
//  API.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Genome
import Alamofire
import UIKit

open class API <T> where T: NodeInitializable {
    
    open var path: URLRequest
    open var queryParams: [String: String]?
    open var bodyParams: [String: Any]?
    open var method: HTTPMethod
    open var headers: [String: String] = [:]
    open var interceptors: [Interceptor] = []
    open var logger: Loggable?
    
    var curl: String?
    
    var manager : Alamofire.SessionManager
    
    let noNetWorkCodes = Set([
        NSURLErrorCannotFindHost,
        NSURLErrorCannotConnectToHost,
        NSURLErrorNetworkConnectionLost,
        NSURLErrorDNSLookupFailed,
        NSURLErrorHTTPTooManyRedirects,
        NSURLErrorNotConnectedToInternet
        ])
    
    public init(path: URL, method: HTTPMethod, queryParams: [String: String]?, bodyParams: [String: Any]?, headers: [String: String]?, interceptors: [Interceptor]?) {
        
        self.path = try! URLRequest(url: path, method: method)
        
        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.method = method
        if headers != nil {
            self.headers = headers!
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        manager = Alamofire.SessionManager(configuration: configuration)
        
        if interceptors != nil {self.interceptors.append(contentsOf: interceptors!)}
    }
    
    func beforeRequest() {
        for interceptor in interceptors {
            interceptor.requestInterceptor(self)
        }
        if queryParams != nil {
            self.path = try! URLEncoding.queryString.encode(self.path, with: queryParams)
        }
    }
    
    
    open func processJSONResponse(_ onSuccess: @escaping (_ result: Response<T>?) -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void)
        -> ((_ response: DataResponse<Any>) -> Void) {
            
            return { (response: DataResponse<Any>) -> Void in
                
                for interceptor in self.interceptors {
                    interceptor.responseInterceptor(self, response: response)
                }
                
                
                switch response.result {
                case .success:
                    if Utils.isSuccessfulRequest(response: response) {
                        var instance: T? = nil // For empty results
                        if let _ = response.result.value {
                            if let node = try? response.data!.makeNode() {
                                instance = try! T(node: node)
                            }
                        }
                        let responseBody = Response<T>(response.response?.statusCode, body: instance)
                        onSuccess(responseBody)
                    } else {
                        let error = RestError(rawValue: response.response?.statusCode ?? RestErrorType.unknow.rawValue,
                                              rawIsHttpCode: true,
                                              rawResponse: response.result.value,
                                              rawResponseData: response.data)
                        onError(error)
                    }
                case .failure(let _error):
                    
                    let errorType = response.response?.statusCode ?? (self.noNetWorkCodes.contains(_error._code) ? RestErrorType.noNetwork.rawValue :RestErrorType.unknow.rawValue)
                    
                    let error = RestError(rawValue: _error._code == NSURLErrorTimedOut ? RestErrorType.noNetwork.rawValue : errorType,
                                          rawIsHttpCode: true,
                                          rawResponse: response.result.value,
                                          rawResponseData: response.data)
                    onError(error)
                }
                
                always()
            }
    }
    
    open func upload(_ onProgress: @escaping (_ progress: Float) -> Void, onSuccess: @escaping (_ result: Response<T>?) -> Void,
                     onError: @escaping (RestError?) -> Void,
                     always: @escaping () -> Void) {
        
        assert(self.method == .post)
        assert((self.bodyParams?.count ?? 0) == 1)
        
        self.beforeRequest()
        
        Alamofire.upload(multipartFormData: {form in
            for (key,item) in self.bodyParams! {
                assert(item is UIImage || item is Data)
                if let _item = item as? UIImage {
                    let data = UIImagePNGRepresentation(_item)!
                    form.append(data, withName: key, fileName: key, mimeType: "image/png")
                } else {
                    let data = item as! Data
                    form.append(data, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(), to: self.path.url!, method: .post, headers: self.headers, encodingCompletion: {result in
            switch (result) {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    onProgress(Float(progress.fractionCompleted))
                })
                
                upload.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
            case .failure(_):
                onError(RestError(rawValue: RestErrorType.formEncodeError.rawValue,
                                  rawIsHttpCode: false,
                                  rawResponse: nil,
                                  rawResponseData: nil))
                always()
            }
        })
        
    }
    
    open func execute( _ onSuccess: @escaping (Response<T>?) -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void) {
        self.beforeRequest()
        
        let request = manager.request(path.url!, method: self.method, parameters: bodyParams, encoding: JSONEncoding.default, headers: headers)
        
        self.curl = request.debugDescription
        request.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
    }
    
}
