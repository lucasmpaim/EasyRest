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

public class Service<R: Routable> {
    
    public var interceptors: [Interceptor]? {return nil}
    
    public var base: String {
        get {
            fatalError("Override to provide baseUrl")
        }
    }
    
    public func builder<T: MappableBase>(routes: R,
                                         type: T.Type) throws -> APIBuilder<T> {
        return try routes.builder(base, type: type)
    }
    
    public func call<E: MappableBase>(routes: R,
                                      type: E.Type,
                                      onSuccess: (result: E?) -> Void,
                                      onError: (RestError?) -> Void,
                                      always: () -> Void) throws {
        try builder(routes, type: type).build().execute(onSuccess, onError: onError, always: always)
    }

    public func upload<E: MappableBase>(routes: R, type: E.Type,
                                        onSuccess: (result: E?) -> Void,
                                        onProgress: (progress: Float) -> Void,
                                        onError: (RestError?) -> Void,
                                        always: () -> Void) throws {
        try builder(routes, type: type).build().upload(onSuccess,
                onProgress: onProgress,
                onError: onError,
                always: always)
    }
}