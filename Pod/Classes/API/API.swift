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

open class API <T: MappableBase> {
        
    open var path: URLRequest
    open var queryParams: [String: String]?
    open var bodyParams: [String: Any]?
    open var method: HTTPMethod
    open var headers: [String: String] = [:]
    open var interceptors: [Interceptor] = []
    open var logger: Logger?

    var curl: String?

    public init(path: URL, method: HTTPMethod, queryParams: [String: String]?, bodyParams: [String: Any]?, headers: [String: String]?, interceptors: [Interceptor]?) {
        
        self.path = URLRequest(url: path)

        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.method = method
        if headers != nil {
            self.headers = headers!
        }
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


    open func processJSONResponse(_ onSuccess: @escaping (_ result: T?) -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void)
                    -> ((_ response: DataResponse<Any>) -> Void) {

        return { (response: DataResponse<Any>) -> Void in

            for interceptor in self.interceptors {
                interceptor.responseInterceptor(self, response: response)
            }

            if Utils.isSuccessfulRequest(response: response) {
                var instance: T? = nil // For empty results
                if let _ = response.result.value {
                    
                    let node = Node(any: response.data!)
                    instance = try! T(node: node)
                }
                onSuccess(instance)
            } else {
                let error = RestError(rawValue: response.response?.statusCode ?? RestErrorType.unknow.rawValue,
                        rawIsHttpCode: true,
                        rawResponse: response.result.value,
                        rawResponseData: response.data)
                onError(error)
            }

            always()
        }
    }

    open func upload(_ onProgress: @escaping (_ progress: Float) -> Void, onSuccess: @escaping (_ result: T?) -> Void,
                       onError: @escaping (RestError?) -> Void,
                       always: @escaping () -> Void) {

        assert(self.method == .post)
        assert((self.bodyParams?.count ?? 0) == 1)

        self.beforeRequest()

//        Alamofire.upload(self.path,
//                method: self.method,
//                multipartFormData: {form in
//                    for (key,item) in self.bodyParams! {
//                        assert(item is UIImage || item is NSData)
//                        if let _item = item as? UIImage {
//                            let data = UIImagePNGRepresentation(_item)!
//                            form.appendBodyPart(data: data, name: key, fileName: "\(key).png", mimeType: "image/png")
//                        } else {
//                            let data = item as! NSData
//                            form.appendBodyPart(data: data, name: key)
//                        }
//                    }
//                },
//                encodingCompletion: { result in
//                    switch (result) {
//                    case .Success(let upload, _, _):
//                        upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
//                            let percent = (Float(totalBytesWritten) * 100) / Float(totalBytesExpectedToWrite)
//                            onProgress(progress: percent)
//                        }
//                        upload.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
//                    case .Failure(_):
//                        onError(RestError(rawValue: RestErrorType.FormEncodeError.rawValue,
//                                rawIsHttpCode: false,
//                                rawResponse: nil,
//                                rawResponseData: nil))
//                        always()
//                    }
//                })
    }
    
    open func execute( _ onSuccess: @escaping (T?) -> Void, onError: @escaping (RestError?) -> Void, always: @escaping () -> Void) {
        self.beforeRequest()
        let request = Alamofire.request(path.url!, method: self.method, parameters: bodyParams, encoding: URLEncoding.default, headers: headers)
        self.curl = request.debugDescription
        request.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
    }
    
}
