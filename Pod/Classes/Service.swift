//
//  Service.swift
//  Pods
//
//  Created by Vithorio Polten on 3/25/16.
//  Base on Tof Template
//
//
import Foundation
import Genome

open class Service<R: Routable> {
    
    open var interceptors: [Interceptor]? {return nil}
    
    open var base: String {
        get {
            fatalError("Override to provide baseUrl")
        }
    }
    
    open func builder<T: NodeInitializable>(_ routes: R,
                                         type: T.Type) throws -> APIBuilder<T> {
        return try routes.builder(base, type: type)
    }
    
    open func call<E: NodeInitializable>(_ routes: R,
                                      type: E.Type,
                                      onSuccess: @escaping (Response<E>?) -> Void,
                                      onError: @escaping (RestError?) -> Void,
                                      always: @escaping () -> Void) throws {
        try builder(routes, type: type).build().execute(onSuccess, onError: onError, always: always)
    }

    open func upload<E: NodeInitializable>(_ routes: R, type: E.Type,
                                        onProgress: @escaping (Float) -> Void,
                                        onSuccess: @escaping (Response<E>?) -> Void,
                                        onError: @escaping (RestError?) -> Void,
                                        always: @escaping () -> Void) throws {
        try builder(routes, type: type).build().upload(
                onProgress,
                onSuccess: onSuccess,
                onError: onError,
                always: always)
    }
}
