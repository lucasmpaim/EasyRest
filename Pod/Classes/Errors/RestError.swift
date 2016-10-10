//
//  RestError.swift
//  Pods
//
//  Created by Guizion Labs on 24/08/16.
//
//

import Foundation

public class RestError: ErrorType {
    
    public let cause: RestErrorType
    public let httpResponseCode: Int?
    public let rawResponse: AnyObject?
    public let rawResponseData: NSData?
    
    public init(rawValue: Int, rawIsHttpCode: Bool = false, rawResponse: AnyObject? = nil, rawResponseData: NSData? = nil) {
        if let _cause = RestErrorType(rawValue: rawValue) {
            self.cause = _cause
        } else {
            self.cause = .Unknow
        }
        
        self.httpResponseCode = rawIsHttpCode ? rawValue : nil
        self.rawResponse = rawResponse
        self.rawResponseData = rawResponseData
    }
    
}