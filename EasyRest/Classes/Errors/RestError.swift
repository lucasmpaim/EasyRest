//
//  RestError.swift
//  Pods
//
//  Created by Guizion Labs on 24/08/16.
//
//

import Foundation

open class RestError: Error {
    
    public let cause: RestErrorType
    public let httpResponseCode: Int?
    public let rawResponse: Any?
    public let rawResponseData: Data?
    
    public init(rawValue: Int, rawIsHttpCode: Bool = false, rawResponse: Any? = nil, rawResponseData: Data? = nil) {
        if let _cause = RestErrorType(rawValue: rawValue) {
            self.cause = _cause
        } else {
            self.cause = .unknow
        }
        
        self.httpResponseCode = rawIsHttpCode ? rawValue : nil
        self.rawResponse = rawResponse
        self.rawResponseData = rawResponseData
    }
    
}
