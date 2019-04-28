//
//  Response.swift
//  Pods
//
//  Created by Lucas Paim on 12/12/16.
//
//

import Foundation

open class Response<T> where T: Codable {
    public let httpStatusCode: Int?
    public let body: T?
    
    init(_ statusCode: Int?, body: T?) {
        self.httpStatusCode = statusCode
        self.body = body
    }
    
}
