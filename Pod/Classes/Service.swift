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
    public var interceptors: [Interceptor]? { return nil }
    
    public var base: String {
        get {
            fatalError("Override to provide baseUrl")
        }
    }
    
    public func call<E: MappableBase>(routes: R, type: E.Type, onSuccess: (result: E?) -> Void, onError: (ErrorType?) -> Void, always: () -> Void) throws {
        let builder = try routes.builder(base, type: E.self)
        
        builder.build().execute(onSuccess, onError: onError, always: always)
    }
}