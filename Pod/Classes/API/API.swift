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
import UIKit

public class API <T: JsonConvertibleType> {
        
    public var path: NSURLRequest
    public var queryParams: [String: String]?
    public var bodyParams: [String: AnyObject]?
    public var method: Alamofire.Method
    public var headers: [String: String] = [:]
    public var interceptors: [Interceptor] = []
    public var logger: Logger?

    var curl: String?

    public init(path: NSURL, method: Alamofire.Method, queryParams: [String: String]?, bodyParams: [String: AnyObject]?, headers: [String: String]?, interceptors: [Interceptor]?) {
        
        self.path = NSURLRequest(URL: path)

        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.method = method
        if headers != nil {
            self.headers = headers!
        }
        if interceptors != nil {self.interceptors.appendContentsOf(interceptors!)}
    }

    func beforeRequest() {
        if queryParams != nil {
            self.path = ParameterEncoding.URLEncodedInURL.encode(self.path, parameters: queryParams).0
        }
        for interceptor in interceptors {
            interceptor.requestInterceptor(self)
        }
    }


    public func processJSONResponse(onSuccess: (result: T?) -> Void, onError: (RestError?) -> Void, always: () -> Void)
                    -> ((response: Response<AnyObject, NSError>) -> Void) {

        return { (response: Response<AnyObject, NSError>) -> Void in

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

    public func upload(onProgress: (progress: Float) -> Void, onSuccess: (result: T?) -> Void, onError: (RestError?) -> Void, always: () -> Void) {

        assert(self.method == .POST)
        assert((self.bodyParams?.count ?? 0) == 1)


        Alamofire.upload(self.method,
                self.path,
                multipartFormData: {form in
                    for (key,item) in self.bodyParams! {
                        assert(item is UIImage || item is NSData)
                        let data: NSData
                        if let _item = item as? UIImage {
                            data = UIImagePNGRepresentation(_item)!
                        } else {
                            data = item as! NSData
                        }
                        form.appendBodyPart(data: data, name: key)
                    }
                },
                encodingCompletion: { result in
                    switch (result) {
                    case .Success(let upload, _, _):
                        upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                            let percent = (Float(totalBytesWritten) * 100) / Float(totalBytesExpectedToWrite)
                            onProgress(progress: percent)
                        }
                        upload.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
                    case .Failure(_):
                        onError(RestError(rawValue: RestErrorType.FormEncodeError.rawValue,
                                rawIsHttpCode: false,
                                rawResponse: nil))
                        always()
                    }
                })
    }
    
    public func execute( onSuccess: (result: T?) -> Void, onError: (RestError?) -> Void, always: () -> Void) {
        self.beforeRequest()
        let request = Alamofire.request(method, path.URLString, parameters: bodyParams, encoding: ParameterEncoding.JSON, headers: headers)
        self.curl = request.debugDescription
        request.responseJSON(completionHandler: self.processJSONResponse(onSuccess, onError: onError, always: always))
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