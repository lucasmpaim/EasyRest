//
//  Response.swift
//  Pods
//
//  Created by Lucas Paim on 12/12/16.
//
//

import Foundation
import Genome

open class Response<T> where T: NodeInitializable {
    open let httpStatusCode: Int?
    open let body: T?
    
    init(_ statusCode: Int?, body: T?) {
        self.httpStatusCode = statusCode
        self.body = body
    }
    
}
