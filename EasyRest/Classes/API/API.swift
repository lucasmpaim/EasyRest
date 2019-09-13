//
//  API.swift
//  RestClient
//
//  Created by Guizion Labs on 10/03/16.
//  Copyright © 2016 Guizion Labs. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

open class API <T> where T: Codable {
    
    var curl: String?
    
    open var path: URLRequest
    open var queryParams: [String: String]?
    open var bodyParams: [String: Any]?
    open var method: HTTPMethod
    open var headers: [String: String] = [:]
    open var interceptors: [Interceptor] = []
    open var logger: Loggable?
    
    var cancelled = false
    
    fileprivate var cancelToken: CancelationToken<T>?
    fileprivate var manager : Alamofire.SessionManager
    
    fileprivate let noNetWorkCodes = Set([
        NSURLErrorCannotFindHost,
        NSURLErrorCannotConnectToHost,
        NSURLErrorNetworkConnectionLost,
        NSURLErrorDNSLookupFailed,
        NSURLErrorHTTPTooManyRedirects,
        NSURLErrorNotConnectedToInternet
        ])
    
    public init(path: URL, method: HTTPMethod, queryParams: [String: String]?, bodyParams: [String: Any]?, headers: [String: String]?, interceptors: [Interceptor]?, cancelToken: CancelationToken<T>?) {
        
        self.path = try! URLRequest(url: path, method: method)
        
        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.method = method
        self.cancelToken = cancelToken
        
        if headers != nil {
            self.headers = headers!
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        manager = Alamofire.SessionManager(configuration: configuration)
        
        if interceptors != nil {self.interceptors.append(contentsOf: interceptors!)}

        self.cancelToken?.api = self
    }
    
    func beforeRequest() {
        for interceptor in interceptors {
            interceptor.requestInterceptor(self)
        }
        if queryParams != nil {
            self.path = try! URLEncoding.queryString.encode(self.path, with: queryParams)
        }
    }
    
    open func processResponse<U>(
        _ onSuccess: @escaping (_ result: Response<T>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void) -> ((_ response: DataResponse<U>) -> Void)
    {
            return { (response: DataResponse<U>) -> Void in
                if self.cancelled {
                    // Ignore the result if the request are canceled
                    return
                }
                
                for interceptor in self.interceptors {
                    interceptor.responseInterceptor(self, response: response)
                }

                switch response.result {
                case .success:
                    if Utils.isSuccessfulRequest(response: response) {
                        var instance: T? = nil // For empty results
                        do {
                            if let _ = response.result.value {
                                if response.result.value is Data {
                                    if response.result.value is T {
                                        instance = response.result.value as? T
                                    } else {
                                        self.logger?.error("When downloading raw data, please provide T as Data")
                                    }
                                } else {
                                    instance = try JSONDecoder().decode(T.self, from: response.data!)
                                }
                            }
                        } catch {
                            self.logger?.error(error.localizedDescription)
                            self.logger?.error(error)
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
        
        Alamofire.upload(multipartFormData: { form in
            for (key,item) in self.bodyParams! {
                assert(item is UIImage || item is Data)
                if let _item = item as? UIImage {
                    let data = _item.pngData()!
                    form.append(data, withName: key, fileName: key, mimeType: "image/png")
                } else {
                    let data = item as! Data
                    form.append(data, withName: key, fileName: key, mimeType: "")
                }
            }
        }, usingThreshold: UInt64.init(), to: self.path.url!, method: .post, headers: self.headers, encodingCompletion: { result in
            switch (result) {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    onProgress(Float(progress.fractionCompleted))
                })
                
                upload.responseJSON(completionHandler: self.processResponse(onSuccess, onError: onError, always: always))
            case .failure(_):
                onError(RestError(rawValue: RestErrorType.formEncodeError.rawValue,
                                  rawIsHttpCode: false,
                                  rawResponse: nil,
                                  rawResponseData: nil))
                always()
            }
        })
    }
    
    open func download(
        _ onProgress: @escaping (_ progress: Float) -> Void,
        onSuccess: @escaping (_ result: Response<T>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void)
    {
        assert(self.method == .get)
        self.beforeRequest()
        
        let request = manager.request(path.url!, method: self.method, parameters: bodyParams, encoding: JSONEncoding.default, headers: headers)

        self.curl = request.debugDescription
        
        let callback: ((_ response: DataResponse<Data>) -> Void) =
            self.processResponse(onSuccess, onError: onError, always: always)

        request
            .responseData(completionHandler: callback)
            .downloadProgress(closure: {handler in
                onProgress(Float(handler.fractionCompleted))
            })

        cancelToken?.request = request
    }
    
    open func download(
        _ destination: FileManager.SearchPathDirectory,
        _ onProgress: @escaping (_ progress: Float) -> Void,
        onSuccess: @escaping (_ result: Response<Data>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void)
    {
        assert(self.method == .get)
        self.beforeRequest()
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: destination)
        Alamofire.download(
            path.url!,
            method: self.method,
            parameters: self.bodyParams,
            encoding: JSONEncoding.default,
            headers: headers,
            to: destination)
            .responseData(completionHandler: {response in
                switch response.result {
                case .success(_):
                    let responseBody = Response(
                        response.response?.statusCode,
                        body: response.result.value)
                    onSuccess(responseBody)
                case .failure(_):
                    onError(RestError(rawValue: RestErrorType.formEncodeError.rawValue,
                                      rawIsHttpCode: false,
                                      rawResponse: nil,
                                      rawResponseData: nil))
                }
                
                always()
            })
            .downloadProgress(closure: {handler in
                onProgress(Float(handler.fractionCompleted))
            })
    }
    
    open func execute(
        _ onSuccess: @escaping (Response<T>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void)
    {
        self.beforeRequest()
        
        let request = manager.request(path.url!, method: self.method, parameters: bodyParams, encoding: JSONEncoding.default, headers: headers)
        
        self.curl = request.debugDescription
        request.responseJSON(completionHandler: self.processResponse(
            onSuccess, onError: onError, always: always))
        
        cancelToken?.request = request
    }
    
}
